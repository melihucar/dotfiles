# dotfiles

Ubuntu dev machine for **Python + Next.js**: Hyprland · Ghostty · tmux · Neovim 0.12 · zsh · mise.
Rosé pine everywhere. Symlinked with GNU stow, bootstrapped by one idempotent script.

> Target: **Ubuntu 26.04 LTS** (Hyprland is only in the archive from 26.04).
> Everything except the Hyprland desktop also works on 24.04.

---

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
  (steps: `apt desktop fonts link git mise shell tmux nvim`).

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

## What's where

```
install.sh                 bootstrap: apt → desktop → fonts → stow link → git id → mise → zsh → tmux → nvim
packages/apt-base.txt      CLI + build deps (docker handled in install.sh)
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

**Hyprland** (Super =  ): `Return` terminal · `Space` launcher · `Q` close · `H/J/K/L` focus ·
`Shift+HJKL` move · `Ctrl+HJKL` resize · `1-0` workspaces · `S` scratchpad · `F` maximize · `T` float ·
`C` clipboard history · `Shift+S` region screenshot · `Esc` lock · **`Shift+E` log out** ·
`Alt+Shift` us/tr layout · Caps = Esc.

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

Backups of anything install.sh replaced live in `~/.dotfiles-backup/<timestamp>/`.
