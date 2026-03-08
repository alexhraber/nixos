#!/usr/bin/env bash
# Network: inline ⬇/⬆ speeds + SSID, hover shows full hacker-style details

STATE_DIR=/tmp/waybar_net
mkdir -p "$STATE_DIR"
NOW=$(date +%s)

# Detect active wifi
WIFI_IFACE="" SSID=""
if command -v nmcli &>/dev/null; then
  RAW=$(nmcli -t -f active,ssid,device dev wifi 2>/dev/null | grep '^yes:' | head -1)
  if [[ -n "$RAW" ]]; then
    SSID=$(echo "$RAW" | cut -d: -f2)
    WIFI_IFACE=$(echo "$RAW" | cut -d: -f3)
  fi
fi

# Detect active ethernet
ETH_IFACE=""
if [[ -z "$WIFI_IFACE" ]]; then
  for f in /sys/class/net/en* /sys/class/net/eth*; do
    [[ -f "$f/carrier" ]] || continue
    [[ "$(cat "$f/carrier" 2>/dev/null)" == "1" ]] && ETH_IFACE=$(basename "$f") && break
  done
fi

IFACE="${WIFI_IFACE:-$ETH_IFACE}"

if [[ -z "$IFACE" ]]; then
  jq -cn '{text:"󰤭  no signal",tooltip:"disconnected",class:"disconnected"}'
  exit
fi

# TX/RX delta
RX_NOW=$(cat "/sys/class/net/$IFACE/statistics/rx_bytes" 2>/dev/null || echo 0)
TX_NOW=$(cat "/sys/class/net/$IFACE/statistics/tx_bytes" 2>/dev/null || echo 0)
STATE="$STATE_DIR/$IFACE"

RX_RATE=0; TX_RATE=0
if [[ -f "$STATE" ]]; then
  read -r P_RX P_TX P_TIME < "$STATE"
  DT=$(( NOW - P_TIME ))
  if [[ $DT -gt 0 ]]; then
    RX_RATE=$(( (RX_NOW - P_RX) / DT ))
    TX_RATE=$(( (TX_NOW - P_TX) / DT ))
    [[ $RX_RATE -lt 0 ]] && RX_RATE=0
    [[ $TX_RATE -lt 0 ]] && TX_RATE=0
  fi
fi
echo "$RX_NOW $TX_NOW $NOW" > "$STATE"

fmt_rate() {
  local b=$1 r
  if   [[ $b -ge 1048576 ]]; then r=$(printf "%d.%dM/s" $(( b/1048576 )) $(( (b%1048576)*10/1048576 )))
  elif [[ $b -ge 1024    ]]; then r=$(printf "%dK/s"     $(( b/1024 )))
  else                            r=$(printf "%dB/s"     "$b")
  fi
  printf "%6s" "$r"
}

fmt_total() {
  local b=$1
  if   [[ $b -ge 1073741824 ]]; then printf "%d.%dGB" $(( b/1073741824 )) $(( (b%1073741824)*10/1073741824 ))
  elif [[ $b -ge 1048576    ]]; then printf "%dMB"     $(( b/1048576 ))
  elif [[ $b -ge 1024       ]]; then printf "%dKB"     $(( b/1024 ))
  else                               printf "%dB"      "$b"
  fi
}

IP=$(ip -4 addr show "$IFACE" 2>/dev/null | awk '/inet /{print $2}' | head -1)
GW=$(ip route show default 2>/dev/null | awk '/default via/{print $3; exit}')
MAC=$(cat "/sys/class/net/$IFACE/address" 2>/dev/null)
DNS=$(grep "^nameserver" /etc/resolv.conf 2>/dev/null | awk '{printf "%s  ", $2}' | sed 's/  $//')
RX_S=$(fmt_rate "$RX_RATE")
TX_S=$(fmt_rate "$TX_RATE")
RX_TOT=$(fmt_total "$RX_NOW")
TX_TOT=$(fmt_total "$TX_NOW")

if [[ -n "$WIFI_IFACE" ]]; then
  # WiFi signal strength
  SIGNAL_DBM=$(iw dev "$WIFI_IFACE" link 2>/dev/null | grep -oP 'signal: \K[-0-9]+')
  FREQ_MHZ=$(iw dev "$WIFI_IFACE" link 2>/dev/null | grep -oP 'freq: \K[0-9]+')
  BITRATE=$(iw dev "$WIFI_IFACE" link 2>/dev/null | grep -oP 'tx bitrate: \K[0-9.]+ [A-Z]+')

  # Signal bar
  if [[ -n "$SIGNAL_DBM" ]]; then
    if   [[ $SIGNAL_DBM -ge -50 ]]; then SIG_BAR="▂▄▆█" SIG_QUAL="excellent"
    elif [[ $SIGNAL_DBM -ge -60 ]]; then SIG_BAR="▂▄▆░" SIG_QUAL="good"
    elif [[ $SIGNAL_DBM -ge -70 ]]; then SIG_BAR="▂▄░░" SIG_QUAL="fair"
    elif [[ $SIGNAL_DBM -ge -80 ]]; then SIG_BAR="▂░░░" SIG_QUAL="weak"
    else                                  SIG_BAR="░░░░" SIG_QUAL="poor"
    fi
    SIG_STR="$SIG_BAR  ${SIGNAL_DBM} dBm  (${SIG_QUAL})"
  else
    SIG_STR="n/a"
  fi

  # Frequency band
  if [[ -n "$FREQ_MHZ" ]]; then
    FREQ_GHZ=$(awk "BEGIN{printf \"%.2f\", $FREQ_MHZ/1000}")
    BAND="${FREQ_GHZ} GHz"
  else
    BAND=""
  fi

  TEXT="󰤨  ${SSID}  ${RX_S}⬇ ${TX_S}⬆"
  TOOLTIP="$(printf " %-14s %s\n %-14s %s\n %-14s %s\n %-14s %s\n %-14s %s" \
    "ssid" "$SSID" \
    "iface" "$IFACE" \
    "ip" "${IP:-n/a}" \
    "gateway" "${GW:-n/a}" \
    "mac" "${MAC:-n/a}")"
  [[ -n "$DNS" ]]  && TOOLTIP+="$(printf "\n %-14s %s" "dns" "$DNS")"
  [[ -n "$SIG_STR" ]] && TOOLTIP+="$(printf "\n %-14s %s" "signal" "$SIG_STR")"
  [[ -n "$BAND" ]]  && TOOLTIP+="$(printf "\n %-14s %s" "band" "$BAND")"
  [[ -n "$BITRATE" ]] && TOOLTIP+="$(printf "\n %-14s %s" "link rate" "$BITRATE")"
  TOOLTIP+="$(printf "\n\n %-14s %s⬇  %s⬆" "rate" "$RX_S" "$TX_S")"
  TOOLTIP+="$(printf "\n %-14s %s⬇  %s⬆" "session" "$RX_TOT" "$TX_TOT")"
else
  TEXT="󰈀  ${IFACE}  ${RX_S}⬇ ${TX_S}⬆"
  TOOLTIP="$(printf " %-14s %s\n %-14s %s\n %-14s %s\n %-14s %s\n %-14s %s" \
    "iface" "$IFACE" \
    "ip" "${IP:-n/a}" \
    "gateway" "${GW:-n/a}" \
    "mac" "${MAC:-n/a}" \
    "dns" "${DNS:-n/a}")"
  TOOLTIP+="$(printf "\n\n %-14s %s⬇  %s⬆" "rate" "$RX_S" "$TX_S")"
  TOOLTIP+="$(printf "\n %-14s %s⬇  %s⬆" "session" "$RX_TOT" "$TX_TOT")"
fi

jq -cn --arg t "$TEXT" --arg tt "$TOOLTIP" '{text:$t,tooltip:$tt}'
