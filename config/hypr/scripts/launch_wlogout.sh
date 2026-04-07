#!/usr/bin/env bash

set -euo pipefail

if pgrep -x "wlogout" >/dev/null; then
  pkill -x "wlogout"
  exit 0
fi

confDir="${HOME}/.config"
wLayout="${confDir}/wlogout/layout_1"
wlTmplt="${confDir}/wlogout/style.css"
wlColms=6
hypr_border=10

x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused == true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused == true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select(.focused == true) | .scale' | sed 's/\.//')

export mgn=$((y_mon * 28 / hypr_scale))
export hvr=$((y_mon * 23 / hypr_scale))
export fntSize=$((y_mon * 2 / 100))
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 8))

wlStyle="$(envsubst <"$wlTmplt")"

wlogout -b "$wlColms" -c 0 -r 0 -m 0 \
  --layout "$wLayout" \
  --css <(printf '%s\n' "$wlStyle") \
  --protocol layer-shell
