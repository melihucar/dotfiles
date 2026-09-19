#!/usr/bin/env bash
# Power menu (port of the old sway powermenu.sh, wofi → fuzzel).
#   powermenu.sh          full menu
#   powermenu.sh logout   just "log out?" confirmation (Super+Shift+E, like sway's swaynag)
set -u
menu() { printf '%s\n' "$@" | fuzzel --dmenu --prompt "${PROMPT:-power } " --lines "$#"; }

if [[ ${1:-} == logout ]]; then
  PROMPT="log out? " choice=$(menu "Logout" "Cancel")
else
  choice=$(menu "Shutdown" "Reboot" "Sleep" "Lock" "Logout" "Cancel")
fi

case ${choice:-Cancel} in
  Shutdown) systemctl poweroff ;;
  Reboot)   systemctl reboot ;;
  Sleep)    systemctl suspend ;;
  Lock)     loginctl lock-session ;;
  Logout)   if command -v uwsm >/dev/null && uwsm check is-active >/dev/null 2>&1; then uwsm stop; else hyprctl dispatch exit; fi ;;
  *)        exit 0 ;;
esac
