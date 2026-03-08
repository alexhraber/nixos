#!/usr/bin/env bash
# Notification bell — always visible; lit with count when active

COUNT=$(swaync-client -c 2>/dev/null | tr -d '[:space:]')
[[ -z "$COUNT" || ! "$COUNT" =~ ^[0-9]+$ ]] && COUNT=0

if (( COUNT > 0 )); then
  jq -cn --arg t $'\uf0f3'"  ${COUNT}" '{text:$t,tooltip:"",class:"active"}'
else
  jq -cn --arg t $'\uf1f6' '{text:$t,tooltip:"",class:"idle"}'
fi
