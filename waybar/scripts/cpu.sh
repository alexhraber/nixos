#!/usr/bin/env bash
# CPU usage via /proc/stat delta + temps via lm_sensors

STATE=/tmp/waybar_cpu_state

read -ra s < /proc/stat
c_idle=$(( s[4] + s[5] ))
c_total=0; for v in "${s[@]:1:8}"; do c_total=$(( c_total + v )); done

if [[ -f "$STATE" ]]; then
  read -r p_total p_idle < "$STATE"
  dt=$(( c_total - p_total ))
  di=$(( c_idle  - p_idle  ))
  [[ $dt -gt 0 ]] && USAGE=$(( (dt - di) * 100 / dt )) || USAGE=0
else
  USAGE=0
fi
echo "$c_total $c_idle" > "$STATE"

TEMPS=""
if command -v sensors &>/dev/null; then
  TEMPS=$(sensors -A 2>/dev/null \
    | grep -E "^(Core [0-9]+|Package id|Tdie|Tctl):" \
    | awk '{printf "  %-22s %s\n", $1" "$2, $3}')
fi

TOOLTIP="CPU  ${USAGE}%"
if [[ -n "$TEMPS" ]]; then
  TOOLTIP+=$'\n\n'"🌡 Temperatures"$'\n'"────────────────────────"$'\n'"${TEMPS}"
fi

[[ $USAGE -gt 85 ]] && CLASS=critical || { [[ $USAGE -gt 60 ]] && CLASS=warning || CLASS=normal; }

jq -cn --arg t "  ${USAGE}%" --arg tt "$TOOLTIP" --arg c "$CLASS" \
  '{text:$t,tooltip:$tt,class:$c}'
