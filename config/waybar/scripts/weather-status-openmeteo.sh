#!/bin/bash

if [[ -n $WEATHER_LOCATION ]]; then
  place_data=$(curl -fsS --max-time 4 --get "https://geocoding-api.open-meteo.com/v1/search" \
    --data-urlencode "name=$WEATHER_LOCATION" \
    --data-urlencode "count=1" \
    --data-urlencode "language=en" \
    --data-urlencode "format=json" \
    2>/dev/null | jq -er '.results[0] | [.name, .country, .latitude, .longitude] | @tsv' 2>/dev/null) || {
    echo "Weather unavailable"
    exit 1
  }

  IFS=$'\t' read -r place country latitude longitude <<<"$place_data"
  place="$place, $country"
else
  place_data=$(curl -fsS --max-time 4 "https://ipinfo.io/json" 2>/dev/null | jq -er '[.city, .region, (.loc | split(",")[0]), (.loc | split(",")[1])] | select(all(. != null and . != "")) | @tsv' 2>/dev/null) || {
    echo "Weather unavailable"
    exit 1
  }

  IFS=$'\t' read -r city region latitude longitude <<<"$place_data"
  place="$city, $region"
fi

weather_data=$(curl -fsS --max-time 8 --get "https://api.open-meteo.com/v1/forecast" \
  --data-urlencode "latitude=$latitude" \
  --data-urlencode "longitude=$longitude" \
  --data-urlencode "current=temperature_2m,apparent_temperature,relative_humidity_2m,precipitation,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m,wind_gusts_10m" \
  --data-urlencode "hourly=temperature_2m,apparent_temperature,precipitation,precipitation_probability,weather_code,wind_speed_10m,wind_direction_10m,visibility,uv_index" \
  --data-urlencode "daily=sunrise,sunset" \
  --data-urlencode "timezone=auto" \
  --data-urlencode "forecast_days=3" \
  2>/dev/null) || {
  echo "Weather unavailable"
  exit 1
}

reset=$'\033[0m'
bold=$'\033[1m'
yellow=$'\033[38;5;226m'
cloud=$'\033[38;5;250m'
dark_cloud=$'\033[38;5;244m'
blue=$'\033[38;5;111m'
green=$'\033[38;5;118m'
cyan=$'\033[38;5;45m'
orange=$'\033[38;5;214m'
red=$'\033[38;5;196m'

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

weather_icon() {
  local sun=$yellow
  local cloud_color=$cloud
  local rain=$blue
  local snow=$cyan
  local lightning=$orange

  case $1 in
  0 | 1)
    printf '%s    \\   /    %s\n' "$sun" "$reset"
    printf '%s     .-.     %s\n' "$sun" "$reset"
    printf '%s  - (   ) -  %s\n' "$sun" "$reset"
    printf '%s     `-'\''     %s\n' "$sun" "$reset"
    printf '%s    /   \\    %s\n' "$sun" "$reset"
    ;;
  2)
    printf '%s   \\  /      %s\n' "$sun" "$reset"
    printf '%s _ /""%s.-.    %s\n' "$sun" "$cloud_color" "$reset"
    printf '%s   \\_%s(   ).  %s\n' "$sun" "$cloud_color" "$reset"
    printf '%s   /%s(___(__) %s\n' "$sun" "$cloud_color" "$reset"
    printf '             \n'
    ;;
  3)
    printf '             \n'
    printf '%s     .--.    %s\n' "$dark_cloud" "$reset"
    printf '%s  .-(    ).  %s\n' "$dark_cloud" "$reset"
    printf '%s (___.__)__) %s\n' "$dark_cloud" "$reset"
    printf '             \n'
    ;;
  45 | 48)
    printf '             \n'
    printf '%s _ - _ - _ - %s\n' "$cloud" "$reset"
    printf '%s  _ - _ - _  %s\n' "$cloud" "$reset"
    printf '%s _ - _ - _ - %s\n' "$cloud" "$reset"
    printf '             \n'
    ;;
  71 | 73 | 75 | 77 | 85 | 86)
    printf '%s     .-.     %s\n' "$cloud_color" "$reset"
    printf '%s    (   ).   %s\n' "$cloud_color" "$reset"
    printf '%s   (___(__)  %s\n' "$cloud_color" "$reset"
    printf '%s    *  *  *  %s\n' "$snow" "$reset"
    printf '%s   *  *  *   %s\n' "$snow" "$reset"
    ;;
  95 | 96 | 99)
    printf '%s     .-.     %s\n' "$dark_cloud" "$reset"
    printf '%s    (   ).   %s\n' "$dark_cloud" "$reset"
    printf '%s   (___(__)  %s\n' "$dark_cloud" "$reset"
    printf "%s   ^'^'^'^'    %s\n" "$lightning" "$reset"
    printf "%s    ' ' ' '  %s\n" "$rain" "$reset"
    ;;
  *)
    printf '%s _`/""%s.-.    %s\n' "$sun" "$cloud_color" "$reset"
    printf '%s  ,\\_%s(   ).  %s\n' "$sun" "$cloud_color" "$reset"
    printf '%s   /%s(___(__) %s\n' "$sun" "$cloud_color" "$reset"
    printf "%s     ' ' ' ' %s\n" "$rain" "$reset"
    printf "%s    ' ' ' '  %s\n" "$rain" "$reset"
    ;;
  esac
}

strip_ansi() {
  sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g'
}

visible_length() {
  printf '%s' "$1" | strip_ansi | wc -m
}

pad_right() {
  local value=$1
  local width=$2
  local length padding
  length=$(visible_length "$value")
  padding=$((width - length))
  ((padding < 0)) && padding=0
  printf '%s%*s' "$value" "$padding" ''
}

color_temp() {
  local value=$1
  local color=$green

  if awk -v v="$value" 'BEGIN { exit !(v >= 30) }'; then
    color=$red
  elif awk -v v="$value" 'BEGIN { exit !(v >= 25) }'; then
    color=$orange
  elif awk -v v="$value" 'BEGIN { exit !(v <= 0) }'; then
    color=$cyan
  fi

  printf '%s%+.0f%s' "$color" "$value" "$reset"
}

format_temp_pair() {
  local temp=$1
  local feels=$2
  printf '%s(%s) °C' "$(color_temp "$temp")" "$(color_temp "$feels")"
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

current_data=$(jq -er '
  . as $w |
  ($w.current.time | split(":")[0] + ":00") as $current_hour |
  ($w.hourly.time | index($current_hour)) as $i |
  [
    $w.current.weather_code,
    $w.current.temperature_2m,
    $w.current.apparent_temperature,
    $w.current.relative_humidity_2m,
    $w.current.precipitation,
    $w.hourly.precipitation_probability[$i],
    $w.current.cloud_cover,
    $w.current.wind_speed_10m,
    $w.current.wind_direction_10m,
    $w.current.wind_gusts_10m,
    $w.hourly.uv_index[$i],
    ($w.daily.sunrise[0] | split("T")[1]),
    ($w.daily.sunset[0] | split("T")[1])
  ] | @tsv
' <<<"$weather_data") || {
  echo "Weather unavailable"
  exit 1
}

IFS=$'\t' read -r current_code current_temp current_feels current_humidity current_precip current_precip_chance current_cloud current_wind current_wind_direction current_gusts current_uv sunrise sunset <<<"$current_data"

printf '%s%s%s\n\n' "$bold" "$place" "$reset"
printf '%s UV index: %s%.1f%s\n' "$(describe_weather "$current_code")" "$orange" "$current_uv" "$reset"
printf 'Temp: %s °C Feels: %s °C\n' "$(color_temp "$current_temp")" "$(color_temp "$current_feels")"
printf 'Precip: %s%.1f mm%s Chance: %s%%\n' "$blue" "$current_precip" "$reset" "$current_precip_chance"
printf 'Humidity: %s%% Cloud: %s%%\n' "$current_humidity" "$current_cloud"
printf 'Wind: %s %s%.0f%s km/h Gusts: %s%.0f%s km/h\n' "$(wind_arrow "$current_wind_direction")" "$green" "$current_wind" "$reset" "$green" "$current_gusts" "$reset"
printf 'Sunrise: %s Sunset: %s\n\n' "$sunrise" "$sunset"

get_slot() {
  local day=$1
  local hour=$2

  jq -er --arg time "${day}T${hour}:00" '
    .hourly as $h |
    ($h.time | index($time)) as $i |
    [$h.weather_code[$i], $h.temperature_2m[$i], $h.apparent_temperature[$i], $h.wind_direction_10m[$i], $h.wind_speed_10m[$i], $h.visibility[$i], $h.precipitation[$i], $h.precipitation_probability[$i]] |
    @tsv
  ' <<<"$weather_data"
}

render_block_lines() {
  local slot_data=$1
  local code temp feels wind_direction wind visibility precip precip_chance
  IFS=$'\t' read -r code temp feels wind_direction wind visibility precip precip_chance <<<"$slot_data"

  local desc temp_text wind_text visibility_text rain_text
  desc=$(describe_weather "$code")
  desc=${desc:0:14}
  temp_text=$(format_temp_pair "$temp" "$feels")
  wind_text=$(printf '%s %s%.0f%s km/h' "$(wind_arrow "$wind_direction")" "$green" "$wind" "$reset")
  visibility_text=$(printf '%.0f km' "$(awk -v v="$visibility" 'BEGIN { print v / 1000 }')")
  rain_text=$(printf '%s%.1f mm%s | %s%%' "$blue" "$precip" "$reset" "$precip_chance")

  mapfile -t icon_lines < <(weather_icon "$code")
  pad_right "${icon_lines[0]}" 13; printf ' '; pad_right "$desc" 14; printf '\n'
  pad_right "${icon_lines[1]}" 13; printf ' '; pad_right "$temp_text" 14; printf '\n'
  pad_right "${icon_lines[2]}" 13; printf ' '; pad_right "$wind_text" 14; printf '\n'
  pad_right "${icon_lines[3]}" 13; printf ' '; pad_right "$visibility_text" 14; printf '\n'
  pad_right "${icon_lines[4]}" 13; printf ' '; pad_right "$rain_text" 14; printf '\n'
}

render_day() {
  local day=$1
  local date_name
  date_name=$(date -d "$day" '+%a %d %b')

  local morning_hour=08
  local day_hour=15
  local night_hour=20
  local morning day_slot night
  morning=$(get_slot "$day" "$morning_hour") || return 1
  day_slot=$(get_slot "$day" "$day_hour") || return 1
  night=$(get_slot "$day" "$night_hour") || return 1

  mapfile -t morning_lines < <(render_block_lines "$morning")
  mapfile -t day_lines < <(render_block_lines "$day_slot")
  mapfile -t night_lines < <(render_block_lines "$night")

  printf '                                       ┌─────────────┐\n'
  printf '┌──────────────────────────────┬───────┤ %s%-11s%s ├────────┬──────────────────────────────┐\n' "$bold" "$date_name" "$reset"
  printf '│           Morning            │             Day              │            Night             │\n'
  printf '├──────────────────────────────┼──────────────────────────────┼──────────────────────────────┤\n'
  for i in 0 1 2 3 4; do
    printf '│ '; pad_right "${morning_lines[$i]}" 28; printf ' │ '; pad_right "${day_lines[$i]}" 28; printf ' │ '; pad_right "${night_lines[$i]}" 28; printf ' │\n'
  done
  printf '└──────────────────────────────┴──────────────────────────────┴──────────────────────────────┘\n'
}

jq -er '.hourly.time[0:72] | map(split("T")[0]) | unique[]' <<<"$weather_data" | while read -r day; do
  render_day "$day"
done || {
  echo "Weather unavailable"
  exit 1
}
