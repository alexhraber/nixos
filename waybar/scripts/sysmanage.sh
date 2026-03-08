#!/usr/bin/env bash
choice=$(printf "  Network\n  Audio\n  Appearance\n  System Info\n  Displays" \
  | wofi --dmenu --prompt "" --width 260 --height 250 --hide-scroll --no-actions --insensitive)
case "$choice" in
  *Network)      nm-connection-editor ;;
  *Audio)        pavucontrol ;;
  *Appearance)   nwg-look ;;
  *"System Info") ghostty -e fastfetch ;;
  *Displays)     wdisplays ;;
esac
