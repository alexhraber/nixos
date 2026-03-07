#!/usr/bin/env bash
# Memory usage from /proc/meminfo with nerdy breakdown

declare -A M
while read -r key val _; do
  M["${key%:}"]=$val
done < /proc/meminfo

total=${M[MemTotal]}
avail=${M[MemAvailable]}
free=${M[MemFree]}
used=$(( total - avail ))
cached=${M[Cached]:-0}
buffers=${M[Buffers]:-0}
slab_r=${M[SReclaimable]:-0}
dirty=${M[Dirty]:-0}
anon=${M[AnonPages]:-0}
swap_total=${M[SwapTotal]:-0}
swap_free=${M[SwapFree]:-0}
swap_used=$(( swap_total - swap_free ))
pct=$(( used * 100 / total ))

fmt_k() {
  local kb=$1
  if   [[ $kb -ge 1048576 ]]; then printf "%d.%d GiB" $(( kb / 1048576 )) $(( (kb % 1048576) * 10 / 1048576 ))
  elif [[ $kb -ge 1024    ]]; then printf "%d MiB" $(( kb / 1024 ))
  else                              printf "%d KiB" "$kb"
  fi
}

TOOLTIP="$(printf "Memory  %s / %s  (%d%%)" "$(fmt_k $used)" "$(fmt_k $total)" $pct)"
TOOLTIP+=$'\n'"────────────────────────────────"
TOOLTIP+=$'\n'"$(printf "  %-16s %s" "Available:"   "$(fmt_k $avail)")"
TOOLTIP+=$'\n'"$(printf "  %-16s %s" "Free:"        "$(fmt_k $free)")"
TOOLTIP+=$'\n'"$(printf "  %-16s %s" "Cached:"      "$(fmt_k $cached)")"
TOOLTIP+=$'\n'"$(printf "  %-16s %s" "Buffers:"     "$(fmt_k $buffers)")"
TOOLTIP+=$'\n'"$(printf "  %-16s %s" "Reclaimable:" "$(fmt_k $slab_r)")"
TOOLTIP+=$'\n'"$(printf "  %-16s %s" "Dirty:"       "$(fmt_k $dirty)")"
TOOLTIP+=$'\n'"$(printf "  %-16s %s" "AnonPages:"   "$(fmt_k $anon)")"

if [[ $swap_total -gt 0 ]]; then
  swap_pct=$(( swap_used * 100 / swap_total ))
  TOOLTIP+=$'\n\n'"$(printf "Swap  %s / %s  (%d%%)" "$(fmt_k $swap_used)" "$(fmt_k $swap_total)" $swap_pct)"
fi

[[ $pct -gt 85 ]] && CLASS=critical || { [[ $pct -gt 65 ]] && CLASS=warning || CLASS=normal; }

jq -cn --arg t "  ${pct}%" --arg tt "$TOOLTIP" --arg c "$CLASS" \
  '{text:$t,tooltip:$tt,class:$c}'
