#!/usr/bin/env bash
# Rofi script mode — system actions injected at top of launcher

if [[ -z "$1" ]]; then
  printf "  Lock\0icon\x1fsystem-lock-screen\n"
  printf "  Sleep\0icon\x1fsystem-suspend\n"
  printf "  Logout\0icon\x1fsystem-log-out\n"
  printf "  Reboot\0icon\x1fsystem-reboot\n"
  printf "  Shutdown\0icon\x1fsystem-shutdown\n"
  printf "  Network\0icon\x1fnetwork-wireless\n"
  printf "  Audio\0icon\x1faudio-volume-high\n"
  printf "  Appearance\0icon\x1fpreferences-desktop-theme\n"
else
  case "$1" in
    *Lock)       hyprlock ;;
    *Sleep)      systemctl suspend ;;
    *Logout)     hyprctl dispatch exit 0 ;;
    *Reboot)     systemctl reboot ;;
    *Shutdown)   systemctl poweroff ;;
    *Network)    nm-connection-editor ;;
    *Audio)      pavucontrol ;;
    *Appearance) nwg-look ;;
  esac
fi
