#!/usr/bin/env bash
# Network: inline ⬇/⬆ speeds + SSID, hover shows full details

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
  jq -cn '{text:"󰤭  no signal",tooltip:"Disconnected",class:"disconnected"}'
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

fmt_bytes() {
  local b=$1
  if   [[ $b -ge 1048576 ]]; then printf "%d.%dM" $(( b/1048576 )) $(( (b%1048576)*10/1048576 ))
  elif [[ $b -ge 1024    ]]; then printf "%dK"     $(( b/1024 ))
  else                            printf "%dB"     "$b"
  fi
}

fmt_bytes_long() {
  local b=$1
  if   [[ $b -ge 1048576 ]]; then printf "%d.%d MB/s" $(( b/1048576 )) $(( (b%1048576)*10/1048576 ))
  elif [[ $b -ge 1024    ]]; then printf "%d KB/s"     $(( b/1024 ))
  else                            printf "%d B/s"      "$b"
  fi
}

IP=$(ip -4 addr show "$IFACE" 2>/dev/null | awk '/inet /{print $2}' | head -1)
RX_S=$(fmt_bytes "$RX_RATE")
TX_S=$(fmt_bytes "$TX_RATE")
RX_L=$(fmt_bytes_long "$RX_RATE")
TX_L=$(fmt_bytes_long "$TX_RATE")

if [[ -n "$WIFI_IFACE" ]]; then
  TEXT="󰤨  ${SSID}  ⬇${RX_S} ⬆${TX_S}"
  TOOLTIP="$(printf "  %-12s %s\n  %-12s %s\n  %-12s %s\n\n  ⬇ %-10s %s\n  ⬆ %-10s %s" \
    "SSID:" "$SSID" "Interface:" "$IFACE" "IP:" "${IP:-n/a}" \
    "Down:" "$RX_L" "Up:" "$TX_L")"
else
  TEXT="󰈀  ${IFACE}  ⬇${RX_S} ⬆${TX_S}"
  TOOLTIP="$(printf "  %-12s %s\n  %-12s %s\n\n  ⬇ %-10s %s\n  ⬆ %-10s %s" \
    "Interface:" "$IFACE" "IP:" "${IP:-n/a}" \
    "Down:" "$RX_L" "Up:" "$TX_L")"
fi

jq -cn --arg t "$TEXT" --arg tt "$TOOLTIP" '{text:$t,tooltip:$tt}'
