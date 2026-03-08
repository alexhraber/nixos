#!/usr/bin/env bash
choice=$(printf "󰤨  Network\n  Audio\n  Appearance\n  System Info" \
  | wofi --dmenu --prompt "" --width 240 --height 220 --hide-scroll --no-actions --insensitive)
case "$choice" in
  *Network*)     nm-connection-editor ;;
  *Audio*)       pavucontrol ;;
  *Appearance*)  nwg-look ;;
  *"System Info"*) ghostty -e fastfetch ;;
esac
