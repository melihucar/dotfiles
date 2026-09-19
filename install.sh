#!/usr/bin/env bash
# Bootstrap / re-sync this machine. Safe to re-run.
#
#   ./install.sh            everything
#   ./install.sh link       only (re)link dotfiles with stow
#   ./install.sh <step>...  any of: apt desktop fonts link git mise shell tmux nvim
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$DOTFILES/stow"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
ALL_STEPS=(apt desktop fonts link git mise shell tmux nvim)

c_blue=$'\e[34m'; c_yellow=$'\e[33m'; c_red=$'\e[31m'; c_green=$'\e[32m'; c_off=$'\e[0m'
info() { printf '%s==>%s %s\n' "$c_blue" "$c_off" "$*"; }
warn() { printf '%s!!%s  %s\n' "$c_yellow" "$c_off" "$*"; }
die()  { printf '%sxx%s  %s\n' "$c_red" "$c_off" "$*" >&2; exit 1; }
ok()   { printf '%sok%s  %s\n' "$c_green" "$c_off" "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# read a package list, dropping comments/blank lines
pkg_list() { sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$1"; }

installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q 'install ok installed'; }

apt_install_list() {
  local file=$1 pkg available=() missing=()
  while IFS= read -r pkg; do
    installed "$pkg" && continue   # never touch what's already there (avoids surprise upgrades)
    if apt-cache show "$pkg" >/dev/null 2>&1; then available+=("$pkg"); else missing+=("$pkg"); fi
  done < <(pkg_list "$file")
  if ((${#available[@]})); then
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${available[@]}"
  fi
  if ((${#missing[@]})); then
    warn "not in apt for this Ubuntu release: ${missing[*]}"
  fi
  MISSING_PKGS=("${missing[@]}")
}

# ---------------------------------------------------------------------------
apt_fix_broken() {
  if ! sudo apt-get check >/dev/null 2>&1; then
    warn "apt has unmet dependencies from before — running 'apt-get -f install' to repair"
    sudo DEBIAN_FRONTEND=noninteractive apt-get -f install -y
  fi
}

step_apt() {
  info "apt: base packages"
  sudo apt-get update -qq
  apt_fix_broken
  apt_install_list "$DOTFILES/packages/apt-base.txt"
  # docker: keep docker-ce if it's already there (it conflicts with Ubuntu's docker.io)
  if have docker; then
    ok "docker present ($(docker --version 2>/dev/null | cut -d, -f1))"
  else
    info "apt: docker (Ubuntu archive)"
    sudo apt-get install -y docker.io docker-compose-v2 docker-buildx
  fi
  if getent group docker >/dev/null && ! id -nG "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER" && warn "added $USER to docker group (log out/in to apply)"
  fi
}

step_desktop() {
  info "apt: Hyprland desktop"
  sudo apt-get update -qq
  apt_fix_broken
  apt_install_list "$DOTFILES/packages/apt-desktop.txt"
  local m
  for m in "${MISSING_PKGS[@]}"; do
    case $m in
      ghostty)
        if have snap; then info "ghostty via snap"; sudo snap install ghostty --classic; fi ;;
      hyprland)
        warn "Hyprland isn't in this Ubuntu's archive (needs 26.04+). Upgrade Ubuntu or use a PPA/build script." ;;
    esac
  done
  # hyprpolkitagent ships a user unit
  systemctl --user enable hyprpolkitagent.service >/dev/null 2>&1 || true
}

step_fonts() {
  local dir="$HOME/.local/share/fonts/FiraCodeNerd"
  if fc-list 2>/dev/null | grep -qi 'FiraCode Nerd Font'; then ok "FiraCode Nerd Font present"; return; fi
  info "fonts: FiraCode Nerd Font"
  mkdir -p "$dir"
  curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz | tar -xJ -C "$dir"
  fc-cache -f "$dir" >/dev/null
}

step_link() {
  have stow || die "stow missing — run ./install.sh apt first"
  info "link: stow packages into $HOME"
  local pkgs=() p line target
  for p in "$STOW_DIR"/*/; do pkgs+=("$(basename "$p")"); done

  # these override the XDG configs we manage (~/.gitconfig beats ~/.config/git/config,
  # ~/.tmux.conf beats ~/.config/tmux/tmux.conf) — move the old ones away
  local legacy=(.tmux.conf .gitconfig .gitconfig.local)
  for target in "${legacy[@]}"; do
    if [[ -e $HOME/$target || -L $HOME/$target ]]; then
      mkdir -p "$BACKUP_DIR"; mv "$HOME/$target" "$BACKUP_DIR/"; warn "moved ~/$target -> $BACKUP_DIR"
    fi
  done

  # real dirs first, so stow links files *inside* them instead of symlinking the whole
  # dir into the repo (otherwise installers writing to ~/.local/bin land in git)
  mkdir -p "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.config"

  # anything stow would refuse to overwrite gets moved into a timestamped backup
  while IFS= read -r line; do
    if [[ $line == *"over existing target "* ]]; then
      target=${line#*over existing target }; target=${target%% *}
    elif [[ $line == *"existing target"*": "* ]]; then
      target=${line##*: }
    else
      continue
    fi
    [[ -z $target ]] && continue
    mkdir -p "$BACKUP_DIR/$(dirname "$target")"
    mv "$HOME/$target" "$BACKUP_DIR/$target"
    warn "backed up ~/$target -> $BACKUP_DIR/$target"
  done < <(stow --dotfiles -n -d "$STOW_DIR" -t "$HOME" "${pkgs[@]}" 2>&1 || true)

  stow --dotfiles --restow -d "$STOW_DIR" -t "$HOME" "${pkgs[@]}"
  # repo guard: block commits containing binaries or files > 512 KB
  git -C "$DOTFILES" config core.hooksPath .githooks
  chmod +x "$HOME"/.local/bin/tmux-sessionizer "$HOME"/.config/hypr/scripts/*.sh 2>/dev/null || true
  touch "$HOME/.config/hypr/monitors.local.conf"
  ok "linked: ${pkgs[*]}"
}

step_git() {
  local f="$HOME/.config/git/local" name email
  [[ -f $f ]] && { ok "git identity: $(git config -f "$f" user.email)"; return; }
  # defaults: GitHub's private noreply address (a real email gets pushes rejected, GH007)
  local def_name="Melih Uçar" def_email="982959+melihucar@users.noreply.github.com"
  name=${GIT_NAME:-}; email=${GIT_EMAIL:-}
  [[ -z $name ]] && read -rp "git user.name [$def_name]: " name
  [[ -z $email ]] && read -rp "git user.email [$def_email]: " email
  name=${name:-$def_name}; email=${email:-$def_email}
  mkdir -p "$(dirname "$f")"
  git config -f "$f" user.name "$name"
  git config -f "$f" user.email "$email"
  ok "wrote $f (untracked)"
}

step_mise() {
  if ! have mise && [[ ! -x $HOME/.local/bin/mise ]]; then
    info "mise: installing"
    curl -fsSL https://mise.run | sh
  fi
  export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
  info "mise: installing tools from ~/.config/mise/config.toml"
  mise install --yes
  mise reshim
  if have bat; then bat cache --build >/dev/null; fi
  if have mise && [[ -d $HOME/.config/zsh/completions ]]; then
    mise completion zsh > "$HOME/.config/zsh/completions/_mise" 2>/dev/null || true
  fi
}

step_shell() {
  local zsh_path; zsh_path=$(command -v zsh) || die "zsh not installed"
  if [[ $(getent passwd "$USER" | cut -d: -f7) != "$zsh_path" ]]; then
    info "shell: switching login shell to zsh"
    chsh -s "$zsh_path"
  fi
  # pre-clone zsh plugins so the first shell is fast
  zsh -ic 'exit' >/dev/null 2>&1 || true
  ok "zsh ready"
}

step_tmux() {
  local tpm="$HOME/.config/tmux/plugins/tpm"
  [[ -d $tpm ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
  info "tmux: installing plugins"
  tmux start-server \; source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || true
  "$tpm/bin/install_plugins" >/dev/null || warn "tpm install failed; run prefix+I inside tmux"
}

step_nvim() {
  export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
  have nvim || die "nvim missing — run ./install.sh mise first"
  # the old config used nvim-treesitter's frozen `master` branch; a leftover clone
  # shadows the new `main` branch, so drop it and let lazy re-clone.
  local ts="$HOME/.local/share/nvim/lazy/nvim-treesitter"
  if [[ -f $ts/lua/nvim-treesitter/configs.lua ]]; then
    warn "removing old nvim-treesitter (master branch) clone"
    rm -rf "$ts"
  fi
  info "nvim: restoring plugins from lazy-lock.json"
  # restore only: `install` would first write the currently-installed commits into the lockfile
  nvim --headless "+Lazy! restore" +qa
  info "nvim: installing LSP servers / formatters (mason)"
  nvim --headless "+MasonToolsInstallSync" +qa
  info "nvim: installing treesitter parsers"
  nvim --headless -c "lua require('nvim-treesitter').install(vim.g.user_ts_parsers):wait(600000)" +qa ||
    warn "parser install failed; they'll install on first nvim start"
  ok "nvim ready"
}

# ---------------------------------------------------------------------------
main() {
  [[ $EUID -eq 0 ]] && die "run as your user, not root"
  grep -qi ubuntu /etc/os-release || warn "not Ubuntu — apt steps may fail"
  local steps=("$@"); ((${#steps[@]})) || steps=("${ALL_STEPS[@]}")
  local s
  for s in "${steps[@]}"; do
    declare -F "step_$s" >/dev/null || die "unknown step: $s (valid: ${ALL_STEPS[*]})"
  done
  if printf '%s\n' "${steps[@]}" | grep -qE '^(apt|desktop|shell)$'; then sudo -v; fi
  for s in "${steps[@]}"; do "step_$s"; done
  ok "done. Open a new terminal (or log out and pick Hyprland)."
}

main "$@"
