#!/usr/bin/env bash

set -euo pipefail

if pgrep -x "wlogout" >/dev/null; then
  pkill -x "wlogout"
  exit 0
fi

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
  hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
fi

confDir="${HOME}/.config"
wLayout="${confDir}/wlogout/layout_1"
wlTmplt="${confDir}/wlogout/style.css"
wlColms=6
hypr_border="${hypr_border:-10}"

# Use logical pixels. Hyprland now emits integer scales such as `1`, so
# stripping the decimal point (the old approach) produced 40,320px margins.
y_mon=$(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | (.height / .scale | floor)')

export mgn=$((y_mon * 28 / 100))
export hvr=$((y_mon * 23 / 100))
export fntSize=$((y_mon * 2 / 100))
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 8))

wlStyle="$(envsubst <"$wlTmplt")"

wlogout -b "$wlColms" -c 0 -r 0 -m 0 \
  --layout "$wLayout" \
  --css <(printf '%s\n' "$wlStyle") \
  --protocol layer-shell
