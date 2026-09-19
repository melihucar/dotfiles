#!/usr/bin/env bash
# Super+K: searchable list of every described keybinding (from `bindd` lines).
hyprctl binds -j | jq -r '
  def mods: [ (if . % 128 >= 64 then "Super" else empty end),
              (if . % 8 >= 4 then "Ctrl" else empty end),
              (if . % 16 >= 8 then "Alt" else empty end),
              (if . % 2 == 1 then "Shift" else empty end) ] | join("+");
  .[] | select(.has_description)
      | ((.modmask | mods) as $m | ($m + (if $m == "" then "" else "+" end) + .key)) as $k
      | "\($k | .[0:28] | . + (" " * (28 - length)))  \(.description)"' |
  fuzzel --dmenu --prompt 'keys  ' --width 70 --lines 25 >/dev/null
