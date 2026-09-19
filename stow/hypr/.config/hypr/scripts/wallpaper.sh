#!/usr/bin/env bash
# Wallpaper for Hyprland. First match wins:
#   1. ~/Pictures/Wallpapers/current.{jpg,jpeg,png,webp}   (your pick; not in git — images stay out of the repo)
#      or ~/Pictures/wallhaven-gw87je.jpg (the old sway wallpaper)
#   2. the wallpaper GNOME is set to (dark variant first)
#   3. a flat rosé pine background
set -u
pick() { [[ -n ${1:-} && -f $1 ]] && exec swaybg -m fill -i "$1"; }

for wp in "$HOME"/Pictures/Wallpapers/current.{jpg,jpeg,png,webp} "$HOME"/Pictures/wallhaven-gw87je.jpg; do pick "$wp"; done

if command -v gsettings >/dev/null; then
  for key in picture-uri-dark picture-uri; do
    uri=$(gsettings get org.gnome.desktop.background "$key" 2>/dev/null | tr -d "'")
    pick "${uri#file://}"
  done
fi

exec swaybg -c '#191724'
