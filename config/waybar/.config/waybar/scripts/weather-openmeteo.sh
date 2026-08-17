#!/bin/bash

if [[ -n $WEATHER_LOCATION ]]; then
  coordinates=$(curl -fsS --max-time 4 --get "https://geocoding-api.open-meteo.com/v1/search" \
    --data-urlencode "name=$WEATHER_LOCATION" \
    --data-urlencode "count=1" \
    --data-urlencode "language=en" \
    --data-urlencode "format=json" \
    2>/dev/null | jq -er '.results[0] | [.latitude, .longitude] | @tsv' 2>/dev/null) || {
    printf '{"text":"","class":"unavailable"}\n'
    exit 0
  }

  IFS=$'\t' read -r latitude longitude <<<"$coordinates"
else
  coordinates=$(curl -fsS --max-time 4 "https://ipinfo.io/json" 2>/dev/null | jq -er '.loc | split(",") | @tsv' 2>/dev/null) || {
    printf '{"text":"","class":"unavailable"}\n'
    exit 0
  }

  IFS=$'\t' read -r latitude longitude <<<"$coordinates"
fi

weather_data=$(curl -fsS --max-time 4 --get "https://api.open-meteo.com/v1/forecast" \
  --data-urlencode "latitude=$latitude" \
  --data-urlencode "longitude=$longitude" \
  --data-urlencode "current=temperature_2m,apparent_temperature,relative_humidity_2m,precipitation,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m,wind_gusts_10m,is_day" \
  --data-urlencode "hourly=precipitation_probability,uv_index" \
  --data-urlencode "daily=sunrise,sunset" \
  --data-urlencode "timezone=auto" \
  --data-urlencode "forecast_days=1" \
  2>/dev/null | jq -er '
    (.current.time | split(":")[0] + ":00") as $current_hour |
    (.hourly.time | index($current_hour)) as $i |
    [
      .current.weather_code,
      .current.temperature_2m,
      .current.apparent_temperature,
      .current.relative_humidity_2m,
      .current.precipitation,
      .hourly.precipitation_probability[$i],
      .current.cloud_cover,
      .current.wind_speed_10m,
      .current.wind_direction_10m,
      .current.wind_gusts_10m,
      .current.is_day,
      .hourly.uv_index[$i],
      (.daily.sunrise[0] | split("T")[1]),
      (.daily.sunset[0] | split("T")[1])
    ] | select(all(. != null)) | @tsv
  ' 2>/dev/null) || {
  printf '{"text":"","class":"unavailable"}\n'
  exit 0
}

IFS=$'\t' read -r weather_code temperature feels_like humidity precipitation precipitation_chance cloud_cover wind_speed wind_direction wind_gusts is_day uv_index sunrise sunset <<<"$weather_data"

if [[ ! $weather_code =~ ^[0-9]+$ || ! $temperature =~ ^-?[0-9]+(\.[0-9]+)?$ || ! $is_day =~ ^[01]$ ]]; then
  printf '{"text":"","class":"unavailable"}\n'
  exit 0
fi

describe_weather() {
  case $1 in
  0) echo "Sunny" ;;
  1) echo "Mainly clear" ;;
  2) echo "Partly cloudy" ;;
  3) echo "Overcast" ;;
  45 | 48) echo "Fog" ;;
  51 | 53 | 55) echo "Drizzle" ;;
  56 | 57) echo "Freezing drizzle" ;;
  61 | 63 | 65) echo "Rain" ;;
  66 | 67) echo "Freezing rain" ;;
  71 | 73 | 75 | 77) echo "Snow" ;;
  80 | 81 | 82) echo "Rain showers" ;;
  85 | 86) echo "Snow showers" ;;
  95 | 96 | 99) echo "Thunderstorm" ;;
  *) echo "Unknown" ;;
  esac
}

wind_arrow() {
  local degrees=$1
  awk -v d="$degrees" 'BEGIN {
    if (d >= 337.5 || d < 22.5) print "↓";
    else if (d < 67.5) print "↙";
    else if (d < 112.5) print "←";
    else if (d < 157.5) print "↖";
    else if (d < 202.5) print "↑";
    else if (d < 247.5) print "↗";
    else if (d < 292.5) print "→";
    else print "↘";
  }'
}

case $weather_code in
0) [[ $is_day == "1" ]] && icon="" || icon="" ;;
1 | 2) [[ $is_day == "1" ]] && icon="" || icon="" ;;
3) icon="" ;;
45 | 48) icon="" ;;
51 | 53 | 55 | 56 | 57 | 61 | 63 | 65 | 66 | 67 | 80 | 81 | 82) icon="" ;;
71 | 73 | 75 | 77 | 85 | 86) icon="" ;;
95 | 96 | 99) icon="" ;;
*) icon="" ;;
esac

temperature=$(printf '%.0f' "$temperature")
tooltip=$(printf '%s UV index: %.1f\nTemp: %+.0f °C Feels: %+.0f °C\nPrecip: %.1f mm Chance: %s%%\nHumidity: %s%% Cloud: %s%%\nWind: %s %.0f km/h Gusts: %.0f km/h\nSunrise: %s Sunset: %s' \
  "$(describe_weather "$weather_code")" "$uv_index" "$temperature" "$feels_like" "$precipitation" "$precipitation_chance" "$humidity" "$cloud_cover" "$(wind_arrow "$wind_direction")" "$wind_speed" "$wind_gusts" "$sunrise" "$sunset")

jq -cn --arg text "$icon  ${temperature}°C" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'
