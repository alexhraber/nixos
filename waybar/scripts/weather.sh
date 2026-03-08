#!/usr/bin/env bash
# Weather for zip 97750 via wttr.in — refreshes every 10 min via cache

CACHE=/tmp/waybar_weather
AGE=600

if [[ -f "$CACHE" ]] && (( $(date +%s) - $(stat -c %Y "$CACHE") < AGE )); then
  DATA=$(cat "$CACHE")
else
  DATA=$(curl -sf --max-time 5 "https://wttr.in/97750?format=j1" 2>/dev/null)
  [[ -n "$DATA" ]] && echo "$DATA" > "$CACHE"
fi

if [[ -z "$DATA" ]]; then
  jq -cn '{text:"",tooltip:"weather unavailable",class:"normal"}'
  exit 0
fi

TEMP_F=$(echo "$DATA"    | jq -r '.current_condition[0].temp_F')
FEELS=$(echo "$DATA"     | jq -r '.current_condition[0].FeelsLikeF')
HUMIDITY=$(echo "$DATA"  | jq -r '.current_condition[0].humidity')
WIND=$(echo "$DATA"      | jq -r '.current_condition[0].windspeedMiles')
WIND_DIR=$(echo "$DATA"  | jq -r '.current_condition[0].winddir16Point')
COND=$(echo "$DATA"      | jq -r '.current_condition[0].weatherDesc[0].value')

HOUR=$(date +%-H)
IS_NIGHT=false
(( HOUR < 6 || HOUR >= 20 )) && IS_NIGHT=true

COND_L=$(echo "$COND" | tr '[:upper:]' '[:lower:]')

if   [[ "$COND_L" =~ (thunder|storm|lightning) ]];     then GLYPH=$'\uf76d'   #
elif [[ "$COND_L" =~ (blizzard|snow|sleet|ice) ]];     then GLYPH=$'\uf2dc'   #
elif [[ "$COND_L" =~ (rain|drizzle|shower) ]];         then GLYPH=$'\uf73d'   #
elif [[ "$COND_L" =~ (fog|mist|haze|smoke) ]];         then GLYPH=$'\uf75f'   #
elif [[ "$COND_L" =~ (overcast) ]];                    then GLYPH=$'\uf0c2'   #
elif [[ "$COND_L" =~ (partly|cloud) ]]; then
  $IS_NIGHT && GLYPH=$'\uf6c4' || GLYPH=$'\ue213'     # /
elif [[ "$COND_L" =~ (clear|sunny|bright|fair) ]]; then
  $IS_NIGHT && GLYPH=$'\uf186' || GLYPH=$'\uf185'     # /
else
  $IS_NIGHT && GLYPH=$'\uf186' || GLYPH=$'\uf185'
fi

TEXT="${TEMP_F}°F ${GLYPH}"
TOOLTIP=$(printf "%-12s %s\n%-12s %s°F\n%-12s %s°F\n%-12s %s%%\n%-12s %s mph %s" \
  "Condition:"  "$COND" \
  "Temp:"       "$TEMP_F" \
  "Feels like:" "$FEELS" \
  "Humidity:"   "$HUMIDITY" \
  "Wind:"       "$WIND" "$WIND_DIR")

jq -cn --arg t "$TEXT" --arg tt "$TOOLTIP" '{text:$t,tooltip:$tt,class:"normal"}'
