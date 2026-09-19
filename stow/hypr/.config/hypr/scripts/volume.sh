#!/usr/bin/env bash
# volume.sh up|down|mute [step%] — change volume and show a notification with a progress bar
set -u
sink=@DEFAULT_AUDIO_SINK@
step=${2:-5}
case ${1:-} in
  up)   wpctl set-volume -l 1 "$sink" "${step}%+" ;;
  down) wpctl set-volume "$sink" "${step}%-" ;;
  mute) wpctl set-mute "$sink" toggle ;;
esac
out=$(wpctl get-volume "$sink")                 # e.g. "Volume: 0.45 [MUTED]"
vol=$(awk '{printf "%d", $2*100}' <<<"$out")
if [[ $out == *MUTED* ]]; then title="Muted"; else title="Volume $vol%"; fi
notify-send -a volume -t 1000 -h string:x-canonical-private-synchronous:volume -h "int:value:$vol" "$title"
