# dotfiles

Ubuntu dev machine for **Python + Next.js**: Hyprland · Ghostty · tmux · Neovim 0.12 · zsh · mise.
Rosé pine everywhere. Symlinked with GNU stow, bootstrapped by one idempotent script.

> Target: **Ubuntu 26.04 LTS** (Hyprland is only in the archive from 26.04).
> Everything except the Hyprland desktop also works on 24.04.

---

## Before wiping the disk

- [ ] `~/.dotfiles` committed **and pushed** (`git status` clean, `git log origin/main..` empty)
- [ ] Every repo in `~/Repositories` pushed — find stragglers:
      `for d in ~/Repositories/*/; do git -C "$d" status -s -b 2>/dev/null | grep -qE '^\?\?|^ M|ahead' && echo "$d"; done`
- [ ] Copied to a USB disk / cloud: `~/.ssh` (or just re-create keys), `~/.zshrc.local`, `~/.config/git/local`,
      `~/Documents`, `~/Pictures`, `~/Downloads` (anything you want), browser data is synced by Chrome sign-in
- [ ] Docker volumes you care about (`docker volume ls`) dumped, e.g. `pg_dump`
- [ ] Ubuntu **26.04 LTS** ISO on a USB stick (ubuntu.com/download/desktop → balenaEtcher / `dd`)

## Reinstall checklist

Do these in order on a fresh Ubuntu 26.04 install (GNOME is fine to start from).

### 1. Base system

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y git
```

### 2. Clone and bootstrap

```bash
git clone https://github.com/melihucar/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh 2>&1 | tee log.txt
```

- Asks for your sudo password once, and for the git name/email. **Just press Enter** on both —
  the defaults are `Melih Uçar` and the GitHub noreply address.
- Takes ~10 min (Neovim compiles parsers and installs language servers).
- Safe to re-run; it only does what's missing. Single steps: `./install.sh link`, `./install.sh nvim`, …
  (steps: `apt desktop apps fonts link git mise shell tmux nvim`).

### 3. SSH key for GitHub (pushes go over SSH, pulls over HTTPS)

Open a **new terminal** first so zsh and the mise tools (`gh`) are on PATH.

```bash
ssh-keygen -t ed25519 -C "melihucar@gmail.com"      # Enter for default path, set a passphrase
gh auth login --git-protocol ssh --web              # uploads ~/.ssh/id_ed25519.pub
ssh -T git@github.com                               # "Hi melihucar!"
```

### 4. Log into Hyprland

Log out (**Ctrl+Alt+Delete** in GNOME) → click your name → **gear icon** bottom-right → **Hyprland**.
Check terminal (**Super+Return**), launcher (**Super+Space**), bar, sound.

### 5. Remove GNOME (optional, from inside Hyprland)

```bash
~/.dotfiles/scripts/remove-gnome.sh          # dry run: read the package list
~/.dotfiles/scripts/remove-gnome.sh --apply  # type "yes", then reboot → tuigreet login
```

### 6. Per-machine bits (untracked, recreate by hand if needed)

| File | What |
|---|---|
| `~/.zshrc.local` | secrets, API keys, work aliases |
| `~/.config/hypr/monitors.local.conf` | monitor layout, e.g. `monitor = DP-1, 2560x1440@144, 0x0, 1` (`hyprctl monitors`) |
| `~/.config/git/local` | git name/email (install.sh writes it) |

Optional cleanup of old tools: `scripts/cleanup-legacy.sh` (asks per item).

---

## What gets installed

| Where from | What |
|---|---|
| apt (`packages/apt-base.txt`) | build-essential, git, curl, stow, zsh, tmux, jq, htop, btop, wl-clipboard… |
| Docker's apt repo | docker-ce + compose/buildx plugins (falls back to Ubuntu's `docker.io`) |
| apt (`packages/apt-desktop.txt`) | Hyprland, hyprlock/idle, waybar, fuzzel, mako, greetd+tuigreet, pipewire, nautilus, ghostty |
| vendor `.deb` (each adds its own apt repo → updates via `apt upgrade`) | Google Chrome · VS Code · Claude desktop · ChatGPT desktop (with Codex) |
| mise | node, pnpm, python, uv, neovim, tree-sitter, gh, lazygit, delta, starship, fzf, zoxide, eza, bat, ripgrep, fd, yazi, lazydocker, tldr, xh, **Claude Code** (`claude`), **Codex CLI** (`codex`) |
| Neovim (mason) | basedpyright, ruff, vtsls, eslint, tailwind, css/html/json/yaml/lua/bash/docker LSPs, prettierd, stylua, shfmt, debugpy |

Claude desktop's Cowork tab needs virtualization: install.sh adds you to the `kvm` group (log out/in once).
No official GitHub Desktop for Linux — use `lazygit` (`lg`) and `gh`.

## What's where

```
install.sh                 bootstrap: apt → desktop → apps → fonts → stow link → git id → mise → zsh → tmux → nvim
packages/apt-base.txt      CLI + build deps (docker + desktop apps are handled in install.sh)
packages/apt-desktop.txt   Hyprland stack, greetd/tuigreet, ghostty
scripts/remove-gnome.sh    GNOME/GDM → greetd + tuigreet (dry-run by default)
scripts/cleanup-legacy.sh  interactive removal of nvm, oh-my-zsh, .NET, sway leftovers…
.githooks/pre-commit       refuses binaries and files > 512 KB
stow/<pkg>/                mirrors $HOME; `dot-foo` is linked as `~/.foo`
  zsh git tmux nvim ghostty hypr(+waybar mako fuzzel) starship mise bat lazygit bin audio
```

- **apt** installs the desktop/system; **mise** (`stow/mise/.config/mise/config.toml`) installs node, pnpm,
  python, uv, neovim, tree-sitter and the CLI tools (rg, fd, fzf, eza, bat, delta, lazygit, gh, starship,
  zoxide, yazi) — same versions on any Ubuntu.
- **Neovim plugins** are pinned in `stow/nvim/.config/nvim/lazy-lock.json`; install uses `:Lazy restore`.
- **Audio**: `stow/audio` makes the DELL S2722QC (Radeon HDMI 2) the default output. It names the card by
  PCI slot (`0000_0b_00.1`) — if sound goes elsewhere after hardware changes, check `wpctl status` and
  `pw-dump | jq -r '.[] | select(.info.props["media.class"]=="Audio/Sink") | .info.props["node.name"]'`.

## Daily use

| | |
|---|---|
| New Python project | `pynew api` → uv project with ruff + pytest; `.venv` auto-activates |
| New Next.js app | `nextnew web` → pnpm, TS, Tailwind, ESLint, app router |
| Databases | per-project `docker compose` (Postgres/Redis) |
| Jump to a project | `t` (or `prefix f` in tmux) → fzf over `~/Repositories` → tmux session |
| Update everything | `mise up` · nvim `:Lazy update` then commit `lazy-lock.json` · `zplug-update` · tmux `prefix U` |

## Keys

**Hyprland** (Super =  , same keys as the old sway config):
`Return` terminal · `D` / `Space` launcher · `Q` close · `H/J/K/L` or arrows focus · `Shift+HJKL` move ·
`Ctrl+HJKL` resize (`R` = resize mode) · `1-0` workspaces (1 = right screen, 0 = left) · `F` fullscreen ·
`Shift+F` maximize · `Shift+Space` float · `B`/`V` next window right/below · `S`/`W` tabs (group), `Alt+Tab` next tab ·
`E` toggle split · `-` scratchpad (`Shift+-` send there) · `Shift+C` reload · `Shift+E` log out (asks) ·
`Shift+Esc` or `Shift+Calculator` power menu · `Esc` lock · `Shift+B` browser · `N` files · `C` clipboard history ·
`Shift+S` region screenshot · keyboard: Turkish Q.

**tmux** (prefix `C-a`): `|` `-` split · `C-h/j/k/l` move (shared with nvim) · `f` projects · `g` lazygit ·
`s` sessions · `r` reload.

**Neovim** (leader `,`): `ff` files · `fg` grep · `fs` symbols · `\` explorer · `lg` lazygit ·
`gd/gr/gI/gy` LSP · `rn` rename · `ca` action · `cf` format · `uf` toggle format-on-save ·
`tn/tf` tests · `db` breakpoint · `F5` debug · `C-\` terminal. `,fk` lists everything.

**Terminal copy/paste**: `Ctrl+Shift+C` / `Ctrl+Shift+V` (plain `Ctrl+C` interrupts).

## Troubleshooting (things that already bit us)

| Symptom | Fix |
|---|---|
| apt: "unmet dependencies" (e.g. `claude-desktop` wants `xdg-desktop-portal`) | `sudo apt --fix-broken install` — install.sh does this automatically |
| `docker-ce` conflicts with `docker.io` | install.sh keeps whichever docker is already installed |
| Neovim: `attempt to call field 'install' (a nil value)` | an old nvim-treesitter clone from a previous config: `rm -rf ~/.local/share/nvim/lazy/nvim-treesitter` then `./install.sh nvim` |
| `lazy-lock.json` shows old commits in `git diff` | leftover plugins got written into it: `git checkout stow/nvim/.config/nvim/lazy-lock.json && ./install.sh nvim` |
| Ghostty: "invalid value … # comment" | Ghostty doesn't allow trailing comments — put comments on their own line |
| Push rejected: file > 100 MB | something landed in a stowed dir that got folded into the repo; the pre-commit hook now blocks it. `git rm --cached <file>` |
| Push rejected: GH007 private email | commit email must be the noreply address: `git config -f ~/.config/git/local user.email 982959+melihucar@users.noreply.github.com`, then `git commit --amend --reset-author` |
| git uses the wrong name/email | an old `~/.gitconfig` overrides `~/.config/git/config`; install.sh moves it to `~/.dotfiles-backup/` |
| No sound | `wpctl status` — check which sink has the `*`; `wpctl set-default <id>` |
| `do-release-upgrade`: no new release | fully update + reboot first; LTS→LTS opens a few weeks after the `.1` point release (`-d` forces it) |
| After a release upgrade | just run `./install.sh` — it re-enables the Docker/Chrome/VS Code/Claude/ChatGPT sources the upgrade disabled and moves Docker to the new release |

Backups of anything install.sh replaced live in `~/.dotfiles-backup/<timestamp>/`.
