#!/usr/bin/env bash
# volume.sh up|down|mute — change volume and show it (like the old sway pamixer + notify-send binds)
set -u
sink=@DEFAULT_AUDIO_SINK@
case ${1:-} in
  up)   wpctl set-volume -l 1 "$sink" 5%+ ;;
  down) wpctl set-volume "$sink" 5%- ;;
  mute) wpctl set-mute "$sink" toggle ;;
esac
out=$(wpctl get-volume "$sink")                 # e.g. "Volume: 0.45 [MUTED]"
vol=$(awk '{printf "%d", $2*100}' <<<"$out")
if [[ $out == *MUTED* ]]; then title="Muted"; else title="Volume $vol%"; fi
notify-send -a volume -t 1000 -h string:x-canonical-private-synchronous:volume -h "int:value:$vol" "$title"
