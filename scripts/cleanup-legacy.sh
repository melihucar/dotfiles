#!/usr/bin/env bash
# Interactive cleanup of tools this setup replaces. Asks before each item; nothing is removed without "y".
set -uo pipefail

ask() { read -rp "$1 [y/N] " a; [[ $a == [yY] ]]; }
rmdir_if() { local d=$1 why=$2; [[ -e $d ]] || return 0; du -sh "$d" 2>/dev/null | cut -f1 | xargs printf '%6s  '; echo "$d  ($why)"; ask "   delete?" && rm -rf "$d"; }

echo "== replaced by this setup =="
rmdir_if "$HOME/.nvm"        "node versions → mise"
rmdir_if "$HOME/.oh-my-zsh"  "zsh framework → plain zsh + 3 plugins"
rmdir_if "$HOME/.yarn"       "yarn cache → pnpm"
rmdir_if "$HOME/.tmux"       "old tpm plugins → ~/.config/tmux/plugins"
rmdir_if "$HOME/.config/alacritty" "terminal → ghostty"
rmdir_if "$HOME/.config/foot"      "terminal → ghostty"
rmdir_if "$HOME/.config/sway"      "WM → hyprland"
rmdir_if "$HOME/.config/wofi"      "launcher → fuzzel"
rmdir_if "$HOME/.config/dunst"     "notifications → mako"

echo; echo "== other stacks (only if you're done with them) =="
rmdir_if "$HOME/.dotnet"          ".NET SDK"
rmdir_if "$HOME/.nuget"           ".NET packages"
rmdir_if "$HOME/.templateengine"  ".NET templates"
rmdir_if "$HOME/RiderProjects"    "Rider projects — check for code first!"
rmdir_if "$HOME/go"               "Go workspace"

echo; echo "== apt packages =="
for p in anydesk alacritty foot sway wofi dunst; do
  if dpkg -s "$p" >/dev/null 2>&1 && ask "apt purge $p?"; then sudo apt-get purge -y "$p"; fi
done
echo "done. (Snaps: 'snap list' — remove with 'sudo snap remove <name>')"
