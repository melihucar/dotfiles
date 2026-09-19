# dotfiles

Ubuntu dev machine for **Python + Next.js**: Hyprland · Ghostty · tmux · Neovim 0.12 · zsh · mise.
Everything is theme'd rosé pine. Symlinked with GNU stow; bootstrapped by one idempotent script.

## Fresh install

```bash
sudo apt install -y git
git clone https://github.com/melihucar/dotfiles ~/.dotfiles
cd ~/.dotfiles && ./install.sh          # asks for git name/email once
# log out → pick Hyprland (or reboot once GNOME is removed)
```

Re-run any time; it only does what's missing. Single steps: `./install.sh link`, `./install.sh nvim`, …
Steps: `apt desktop fonts link git mise shell tmux nvim`.

Existing files that would be overwritten are moved to `~/.dotfiles-backup/<timestamp>/`, never deleted.

## Layout

```
install.sh              bootstrap (apt → fonts → stow → git id → mise → zsh → tmux → nvim)
packages/apt-*.txt      apt packages (base CLI + Hyprland desktop)
scripts/remove-gnome.sh drop GNOME/GDM for greetd+tuigreet (dry-run by default)
scripts/cleanup-legacy.sh  interactive removal of nvm, oh-my-zsh, .NET, sway leftovers…
stow/<pkg>/             mirrors $HOME — stow links stow/<pkg>/X to ~/X (dot-foo → ~/.foo)
  zsh  git  tmux  nvim  ghostty  hypr (+waybar mako fuzzel)  starship  mise  bat  lazygit  bin
```

**Where versions come from:** apt for the desktop/system, **mise** (`stow/mise/.config/mise/config.toml`)
for node, pnpm, python, uv, neovim, and CLI tools (rg, fd, fzf, eza, bat, delta, lazygit, gh, starship, zoxide, yazi).
So the CLI toolchain is the same on any Ubuntu version.

**Local, untracked:** `~/.zshrc.local` (secrets, work aliases), `~/.config/git/local` (identity),
`~/.config/hypr/monitors.local.conf` (monitor layout).

## Daily use

| | |
|---|---|
| New Python project | `pynew api` → uv project with ruff + pytest; `.venv` auto-activates via mise |
| New Next.js app | `nextnew web` → pnpm, TS, Tailwind, ESLint, app router |
| Databases | per-project `docker compose` (Postgres/Redis) — nothing installed globally |
| Jump to a project | `t` (or `prefix f` in tmux) → fzf over `~/Repositories` → tmux session |
| Update tools | `mise up` · nvim `:Lazy update` then commit `lazy-lock.json` · `zplug-update` · `prefix U` (tmux) |

## Keys

**Hyprland** (`SUPER` =  ): `Return` terminal · `Space` launcher · `Q` close · `H/J/K/L` focus ·
`Shift+HJKL` move · `Ctrl+HJKL` resize · `1-0` workspaces · `S` scratchpad · `F` maximize · `T` float ·
`C` clipboard history · `Shift+S` region screenshot · `Esc` lock · `Alt+Shift` us/tr layout · Caps = Esc.

**tmux** (prefix `C-a`): `|` `-` split · `C-h/j/k/l` move (shared with nvim) · `f` projects · `g` lazygit · `s` sessions · `r` reload.

**Neovim** (leader `,`): `ff` files · `fg` grep · `fs` symbols · `\` explorer · `lg` lazygit ·
`gd/gr/gI/gy` LSP · `rn` rename · `ca` action · `cf` format · `uf` toggle format-on-save ·
`tn/tf` tests · `db` breakpoint · `F5` debug · `C-\` terminal. `,fk` lists everything.

Python: basedpyright + ruff (lint, format, imports). Web: vtsls + eslint + tailwind + prettierd.

## Moving off GNOME

1. `./install.sh` (installs Hyprland alongside GNOME), log out, pick **Hyprland**, check everything works.
2. From Hyprland (or a TTY): `scripts/remove-gnome.sh` → read the dry run → `scripts/remove-gnome.sh --apply`.
3. Reboot → tuigreet login.
