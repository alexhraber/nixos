#!/usr/bin/env bash
# Combined clock + NOAA weather for 97750 (Mitchell, OR)
# Runs every 30s for time; NOAA data cached 30min

GRID_CACHE=/tmp/waybar_noaa_grid
FORECAST_CACHE=/tmp/waybar_noaa_forecast
LAT="44.5640"
LON="-120.1529"

# Step 1: get/cache the grid URL (changes rarely, cache 24h)
if ! [[ -f "$GRID_CACHE" ]] || (( $(date +%s) - $(stat -c %Y "$GRID_CACHE" 2>/dev/null || echo 0) > 86400 )); then
  GRID=$(curl -sf --max-time 8 \
    -H "User-Agent: waybar-clock/1.0" \
    "https://api.weather.gov/points/${LAT},${LON}" 2>/dev/null \
    | jq -r '.properties.forecastHourly // empty')
  [[ -n "$GRID" ]] && echo "$GRID" > "$GRID_CACHE"
fi
GRID_URL=$(cat "$GRID_CACHE" 2>/dev/null)

# Step 2: get/cache hourly forecast (30min TTL)
if [[ -n "$GRID_URL" ]]; then
  if ! [[ -f "$FORECAST_CACHE" ]] || (( $(date +%s) - $(stat -c %Y "$FORECAST_CACHE" 2>/dev/null || echo 0) > 1800 )); then
    DATA=$(curl -sf --max-time 8 \
      -H "User-Agent: waybar-clock/1.0" \
      "$GRID_URL" 2>/dev/null)
    [[ -n "$DATA" ]] && echo "$DATA" > "$FORECAST_CACHE"
  fi
fi
DATA=$(cat "$FORECAST_CACHE" 2>/dev/null)

# Clock
TIME=$(date '+%a %b %d  %I:%M %p')

# Weather from NOAA first period (= current hour)
if [[ -n "$DATA" ]]; then
  PERIOD=$(echo "$DATA" | jq '.properties.periods[0]')
  TEMP_F=$(echo "$PERIOD"   | jq -r '.temperature')
  FEELS=$(echo "$PERIOD"    | jq -r '.relativeHumidity.value // "?"')
  WIND=$(echo "$PERIOD"     | jq -r '.windSpeed')
  WIND_DIR=$(echo "$PERIOD" | jq -r '.windDirection')
  COND=$(echo "$PERIOD"     | jq -r '.shortForecast')
  IS_DAY=$(echo "$PERIOD"   | jq -r '.isDaytime')

  COND_L=$(echo "$COND" | tr '[:upper:]' '[:lower:]')

  if   [[ "$COND_L" =~ (thunder|storm) ]];            then GLYPH=$'\uf76d'
  elif [[ "$COND_L" =~ (blizzard|snow|sleet|ice) ]];  then GLYPH=$'\uf2dc'
  elif [[ "$COND_L" =~ (rain|shower|drizzle) ]];      then GLYPH=$'\uf73d'
  elif [[ "$COND_L" =~ (fog|mist|haze) ]];            then GLYPH=$'\uf75f'
  elif [[ "$COND_L" =~ (overcast|cloudy) ]];          then GLYPH=$'\uf0c2'
  elif [[ "$COND_L" =~ (partly|mostly) ]]; then
    [[ "$IS_DAY" == "true" ]] && GLYPH=$'\ue213' || GLYPH=$'\uf6c4'
  else
    [[ "$IS_DAY" == "true" ]] && GLYPH=$'\uf185' || GLYPH=$'\uf186'
  fi

  WEATHER_TEXT="${TEMP_F}°F ${GLYPH}"
  TOOLTIP=$(printf "%-12s %s\n%-12s %s°F\n%-12s %s\n%-12s %s %s" \
    "Condition:" "$COND" \
    "Temp:"      "$TEMP_F" \
    "Wind:"      "$WIND" "$WIND_DIR" \
    "Source:"    "NOAA / weather.gov")
else
  WEATHER_TEXT="--°F"
  TOOLTIP="NOAA data unavailable"
fi

TEXT="${TIME}    ${WEATHER_TEXT}"
jq -cn --arg t "$TEXT" --arg tt "$TOOLTIP" '{text:$t,tooltip:$tt,class:"normal"}'
