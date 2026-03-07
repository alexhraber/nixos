#!/usr/bin/env bash
# CPU usage via /proc/stat delta + per-core usage + temps via lm_sensors

STATE_DIR=/tmp/waybar_cpu
mkdir -p "$STATE_DIR"

# Overall usage
read -ra s < /proc/stat
c_idle=$(( s[4] + s[5] ))
c_total=0; for v in "${s[@]:1:8}"; do c_total=$(( c_total + v )); done

if [[ -f "$STATE_DIR/total" ]]; then
  read -r p_total p_idle < "$STATE_DIR/total"
  dt=$(( c_total - p_total ))
  di=$(( c_idle  - p_idle  ))
  [[ $dt -gt 0 ]] && USAGE=$(( (dt - di) * 100 / dt )) || USAGE=0
else
  USAGE=0
fi
echo "$c_total $c_idle" > "$STATE_DIR/total"

# Per-core usage
CORE_LINES=""
while read -r line; do
  [[ "$line" =~ ^cpu([0-9]+) ]] || continue
  idx="${BASH_REMATCH[1]}"
  read -ra cs <<< "$line"
  core_idle=$(( cs[4] + cs[5] ))
  core_total=0; for v in "${cs[@]:1:8}"; do core_total=$(( core_total + v )); done

  state_file="$STATE_DIR/core${idx}"
  if [[ -f "$state_file" ]]; then
    read -r pc_total pc_idle < "$state_file"
    dct=$(( core_total - pc_total ))
    dci=$(( core_idle  - pc_idle  ))
    [[ $dct -gt 0 ]] && pct=$(( (dct - dci) * 100 / dct )) || pct=0
  else
    pct=0
  fi
  echo "$core_total $core_idle" > "$state_file"

  # Pango gradient bar (10 chars): green→yellow→red
  filled=$(( pct / 10 ))
  bar=""
  for i in 0 1 2 3 4 5 6 7 8 9; do
    if [[ $i -lt $filled ]]; then
      if   [[ $i -lt 3 ]]; then bar+='<span color="#5ee6a8">█</span>'
      elif [[ $i -lt 7 ]]; then bar+='<span color="#ffd166">█</span>'
      else                       bar+='<span color="#ff6b81">█</span>'
      fi
    else
      bar+='<span color="#2a3447">░</span>'
    fi
  done
  CORE_LINES+="$(printf "  <b>%2d</b>  %s  <b>%3d%%</b>\n" "$((idx+1))" "$bar" "$pct")"
done < /proc/stat

# Temperatures
TEMPS=""
if command -v sensors &>/dev/null; then
  TEMPS=$(sensors -A 2>/dev/null \
    | grep -E "^(Core [0-9]+|Package id|Tdie|Tctl):" \
    | awk '{printf "  %-22s %s\n", $1" "$2, $3}')
fi

TOOLTIP="CPU  ${USAGE}%"
if [[ -n "$CORE_LINES" ]]; then
  TOOLTIP+=$'\n\n'"Per-Core Usage"$'\n'"────────────────────────────"$'\n'"${CORE_LINES}"
fi
if [[ -n "$TEMPS" ]]; then
  TOOLTIP+=$'\n'"🌡 Temperatures"$'\n'"────────────────────────────"$'\n'"${TEMPS}"
fi

[[ $USAGE -gt 85 ]] && CLASS=critical || { [[ $USAGE -gt 60 ]] && CLASS=warning || CLASS=normal; }

jq -cn --arg t "$(printf '\xef\x92\xbc')  ${USAGE}%" --arg tt "$TOOLTIP" --arg c "$CLASS" \
  '{text:$t,tooltip:$tt,class:$c}'
