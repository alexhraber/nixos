#!/usr/bin/env bash
# Show notification bell only when count > 0

COUNT=$(swaync-client -c 2>/dev/null | tr -d '[:space:]')
[[ -z "$COUNT" || ! "$COUNT" =~ ^[0-9]+$ ]] && COUNT=0

if (( COUNT > 0 )); then
  jq -cn --arg t $'\uf0f3'"  ${COUNT}" '{text:$t,tooltip:"",class:"active"}'
else
  echo '{"text":"","tooltip":"","class":"hidden"}'
fi
