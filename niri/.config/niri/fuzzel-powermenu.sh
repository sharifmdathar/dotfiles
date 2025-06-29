#!/bin/bash

# Define menu with key prefixes for fast filtering
options="u:   Shutdown
r:   Reboot
l:   Lock
e:   Logout
h:   Hibernate
s:   Sleep
c:   Cancel"

# Show the menu and capture choice
choice=$(echo -e "$options" | fuzzel --dmenu --prompt "Power:")

# Extract the key prefix (before colon)
key="${choice%%:*}"

case "$key" in
  u) systemctl poweroff ;;
  r) systemctl reboot ;;
  l) swaylock ;;
  e) loginctl terminate-user "$USER" ;;
  h) systemctl hibernate ;;
  s) systemctl suspend ;;
  c|*) exit 0 ;;
esac

