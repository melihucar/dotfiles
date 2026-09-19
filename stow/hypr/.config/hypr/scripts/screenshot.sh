#!/usr/bin/env bash
# screenshot.sh region|screen — region goes to clipboard, screen to ~/Pictures/Screenshots
set -euo pipefail
dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
case "${1:-region}" in
  region) grim -g "$(slurp)" - | tee "$file" | wl-copy --type image/png ;;
  screen) grim "$file" && wl-copy --type image/png < "$file" ;;
esac
notify-send -a screenshot "Screenshot saved" "$file" -i "$file"
