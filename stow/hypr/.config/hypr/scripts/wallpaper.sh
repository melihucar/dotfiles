#!/usr/bin/env bash
# Uses ~/.config/hypr/wallpaper.{jpg,jpeg,png} if present, else a flat rosé pine base.
for wp in ~/.config/hypr/wallpaper.{jpg,jpeg,png}; do
  [[ -f $wp ]] && exec swaybg -m fill -i "$wp"
done
exec swaybg -c '#191724'
