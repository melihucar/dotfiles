#!/usr/bin/env bash
# Remove the GNOME desktop once Hyprland works. Dry run by default.
#
#   scripts/remove-gnome.sh            show what would happen
#   scripts/remove-gnome.sh --apply    do it
#
# Run it from a Hyprland session or a TTY (Ctrl+Alt+F3), never from inside GNOME.
# Replaces GDM with greetd + tuigreet so you still get a login screen.
set -euo pipefail

APPLY=0; [[ ${1:-} == --apply ]] && APPLY=1
info() { printf '\e[34m==>\e[0m %s\n' "$*"; }
warn() { printf '\e[33m!!\e[0m  %s\n' "$*"; }
die()  { printf '\e[31mxx\e[0m  %s\n' "$*" >&2; exit 1; }
run()  { if ((APPLY)); then "$@"; else printf '   would run: %s\n' "$*"; fi; }
installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q 'install ok installed'; }

# ---- safety checks ---------------------------------------------------------
[[ $EUID -eq 0 ]] && die "run as your user (sudo is used where needed)"
[[ ${XDG_CURRENT_DESKTOP:-} == *GNOME* ]] && die "you're inside GNOME — log into Hyprland or a TTY first"
command -v Hyprland >/dev/null || die "Hyprland isn't installed — run ./install.sh desktop first"
command -v greetd >/dev/null || installed greetd || die "greetd missing — run ./install.sh desktop first"
command -v tuigreet >/dev/null || die "tuigreet missing — install it (apt install tuigreet) before removing GDM"

# ---- 1. login manager: GDM -> greetd ----------------------------------------
session_cmd="Hyprland"
if [[ -f /usr/share/wayland-sessions/hyprland-uwsm.desktop ]] && command -v uwsm >/dev/null; then
  session_cmd="uwsm start hyprland-uwsm.desktop"
elif command -v start-hyprland >/dev/null; then
  session_cmd="start-hyprland"
fi
greeter_user=_greetd; id "$greeter_user" >/dev/null 2>&1 || greeter_user=greeter

info "greetd will launch: $session_cmd (as greeter user '$greeter_user')"
greetd_conf=$(cat <<CONF
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --remember-session --asterisks --sessions /usr/share/wayland-sessions --cmd '$session_cmd'"
user = "$greeter_user"
CONF
)
if ((APPLY)); then
  [[ -f /etc/greetd/config.toml ]] && sudo cp /etc/greetd/config.toml /etc/greetd/config.toml.bak
  printf '%s\n' "$greetd_conf" | sudo tee /etc/greetd/config.toml >/dev/null
else
  printf '   would write /etc/greetd/config.toml:\n%s\n' "$greetd_conf" | sed 's/^/     /'
fi

# ---- 2. keep things GNOME meta-packages would drag out with autoremove --------
keep=(network-manager network-manager-gnome pipewire pipewire-pulse wireplumber bluez
      gnome-keyring libpam-gnome-keyring nautilus xdg-desktop-portal-gtk xdg-user-dirs
      fonts-noto-color-emoji adwaita-icon-theme gsettings-desktop-schemas policykit-1 polkitd
      cups printer-driver-all sudo openssh-client)
to_keep=(); for p in "${keep[@]}"; do installed "$p" && to_keep+=("$p"); done
info "marking as manually installed (so autoremove keeps them): ${to_keep[*]}"
run sudo apt-mark manual "${to_keep[@]}"

# ---- 3. packages to purge ---------------------------------------------------
candidates=(ubuntu-desktop ubuntu-desktop-minimal ubuntu-session ubuntu-settings
            gdm3 gnome-shell gnome-shell-common gnome-session gnome-session-bin gnome-session-common
            gnome-shell-extension-appindicator gnome-shell-extension-desktop-icons-ng
            gnome-shell-extension-ubuntu-dock gnome-shell-extension-ubuntu-tiling-assistant
            gnome-shell-extension-prefs gnome-shell-extension-manager gnome-tweaks
            gnome-control-center gnome-initial-setup gnome-remote-desktop gnome-software
            gnome-startup-applications yaru-theme-gnome-shell mutter mutter-common
            gnome-bluetooth-sendto gnome-online-accounts-gtk gnome-terminal ptyxis)
purge=(); for p in "${candidates[@]}"; do installed "$p" && purge+=("$p"); done
((${#purge[@]})) || { info "nothing GNOME-ish left to remove"; exit 0; }

info "purge: ${purge[*]}"
info "simulating removal (read this list!):"
sudo apt-get -s purge --autoremove "${purge[@]}" | awk '/^Purg|^Remv/ {print "     " $2}' | sort -u

if ((APPLY)); then
  read -rp "Type 'yes' to remove GNOME: " answer
  [[ $answer == yes ]] || die "aborted"
  sudo systemctl disable gdm3.service 2>/dev/null || true
  sudo apt-get purge -y --autoremove "${purge[@]}"
  sudo systemctl enable greetd.service
  # user-level leftovers
  rm -rf "$HOME/.local/share/gnome-shell/extensions" "$HOME/.config/tiling-assistant"
  info "done — reboot and you'll land on the tuigreet login"
else
  echo; warn "dry run only. Re-run with --apply to do it."
fi
