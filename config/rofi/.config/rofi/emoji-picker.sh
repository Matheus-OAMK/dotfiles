#!/usr/bin/env bash
set -euo pipefail

pkill -u "$USER" rofi 2>/dev/null && exit 0

ROFI_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/rofi"
mkdir -p "$ROFI_CACHE_HOME"

emoji_data="${XDG_DATA_HOME:-$HOME/.local/share}/rofi/emoji.db"
recent_data="$ROFI_CACHE_HOME/emoji.recent"
rofi_style="${ROFI_EMOJI_STYLE:-clipboard}"
font_scale="${ROFI_EMOJI_SCALE:-${ROFI_SCALE:-10}}"
font_name="${ROFI_EMOJI_FONT:-${ROFI_FONT:-JetBrainsMono Nerd Font}}"
paste_after_copy="${ROFI_EMOJI_PASTE:-1}"
use_rofile=""
emoji_style=""

usage() {
  cat <<EOF
$(basename "$0") [options]

Options:
  -s, --style [1|2|list|grid|theme]  Rofi layout/theme. 1=list, 2=grid, other=theme name
      --rasi FILE                    Use custom .rasi config file
      --data FILE                    Use custom emoji database
      --no-paste                     Copy only, do not paste with wtype
      --paste                        Copy and paste with wtype (default)
  -h, --help                         Show help

Environment:
  ROFI_EMOJI_STYLE   Default theme/layout, fallback: clipboard
  ROFI_EMOJI_FONT    Font name
  ROFI_EMOJI_SCALE   Font size, fallback: ROFI_SCALE or 10
EOF
}

parse_args() {
  while (($# > 0)); do
    case "$1" in
    -s | --style)
      [[ $# -gt 1 ]] || {
        echo "--style needs argument" >&2
        exit 1
      }
      emoji_style="$2"
      shift
      ;;
    --rasi)
      [[ $# -gt 1 ]] || {
        echo "--rasi needs FILE" >&2
        exit 1
      }
      use_rofile="$2"
      shift
      ;;
    --data)
      [[ $# -gt 1 ]] || {
        echo "--data needs FILE" >&2
        exit 1
      }
      emoji_data="$2"
      shift
      ;;
    --no-paste)
      paste_after_copy=0
      ;;
    --paste)
      paste_after_copy=1
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    esac
    shift
  done
}

get_rofi_pos() {
  [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] || return 0
  command -v hyprctl >/dev/null || return 0
  command -v jq >/dev/null || return 0

  local cursor monitors
  cursor="$(hyprctl cursorpos -j 2>/dev/null)" || return 0
  monitors="$(hyprctl -j monitors 2>/dev/null)" || return 0

  local cx cy
  cx="$(jq -r '.x' <<<"$cursor")"
  cy="$(jq -r '.y' <<<"$cursor")"

  eval "$(jq -r '.[] | select(.focused==true) |
    "mon_w=\(.width) mon_h=\(.height) mon_scale=\(.scale) mon_x=\(.x) mon_y=\(.y) off_l=\(.reserved[0]) off_t=\(.reserved[1]) off_r=\(.reserved[2]) off_b=\(.reserved[3])"' <<<"$monitors")"

  [[ -n "${mon_w:-}" ]] || return 0
  mon_scale="${mon_scale//./}"
  mon_w=$((mon_w * 100 / mon_scale))
  mon_h=$((mon_h * 100 / mon_scale))
  cx=$((cx - mon_x))
  cy=$((cy - mon_y))

  local x_pos x_off y_pos y_off
  if ((cx >= mon_w / 2)); then
    x_pos="east"
    x_off="-$((mon_w - cx - off_r))"
  else
    x_pos="west"
    x_off="$((cx - off_l))"
  fi

  if ((cy >= mon_h / 2)); then
    y_pos="south"
    y_off="-$((mon_h - cy - off_b))"
  else
    y_pos="north"
    y_off="$((cy - off_t))"
  fi

  printf 'window{location:%s %s;anchor:%s %s;x-offset:%spx;y-offset:%spx;}' \
    "$x_pos" "$y_pos" "$x_pos" "$y_pos" "$x_off" "$y_off"
}

setup_rofi_config() {
  local hypr_border=10 hypr_width=2
  if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && command -v hyprctl >/dev/null && command -v jq >/dev/null; then
    hypr_border="$(hyprctl -j getoption decoration:rounding 2>/dev/null | jq '.int' 2>/dev/null || echo 10)"
    hypr_width="$(hyprctl -j getoption general:border_size 2>/dev/null | jq '.int' 2>/dev/null || echo 2)"
  fi

  local wind_border=$((hypr_border * 3 / 2))
  local elem_border=$((hypr_border == 0 ? 5 : hypr_border))
  rofi_position="$(get_rofi_pos)"
  font_override="* {font: \"$font_name $font_scale\";}"
  r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;}listview{border-radius:${elem_border}px;}element{border-radius:${elem_border}px;}"
}

ensure_files() {
  [[ -f "$emoji_data" ]] || {
    echo "Emoji database not found: $emoji_data" >&2
    exit 1
  }
  mkdir -p "$(dirname "$recent_data")"
  if [[ ! -f "$recent_data" ]]; then
    printf '%s\n' ' Arch linux - I use Arch, BTW' >"$recent_data"
  fi
}

save_recent_entry() {
  local emoji_line="$1" tmp
  tmp="$(mktemp)"
  {
    printf '%s\n' "$emoji_line"
    cat "$recent_data"
  } | awk '!seen[$0]++' >"$tmp"
  mv "$tmp" "$recent_data"
}

run_rofi() {
  local style_type="${emoji_style:-$rofi_style}"

  if [[ -n "$use_rofile" ]]; then
    awk '!seen[$0]++' "$recent_data" "$emoji_data" | rofi -dmenu -i \
      -config "$use_rofile" \
      -matching fuzzy -no-custom
    return
  fi

  case "$style_type" in
  2 | grid)
    awk '!seen[$0]++' "$recent_data" "$emoji_data" | rofi -dmenu -i \
      -display-columns 1 \
      -display-column-separator " " \
      -theme-str "listview {columns: 9;}" \
      -theme-str "entry { placeholder: \" 🔎 Emoji\";} $rofi_position $r_override" \
      -theme-str "$font_override" \
      -theme "clipboard" \
      -matching fuzzy -no-custom
    ;;
  1 | list)
    awk '!seen[$0]++' "$recent_data" "$emoji_data" | rofi -dmenu -i \
      -theme-str "entry { placeholder: \" 🔎 Emoji\";} $rofi_position $r_override" \
      -theme-str "$font_override" \
      -theme "clipboard" \
      -matching fuzzy -no-custom
    ;;
  *)
    awk '!seen[$0]++' "$recent_data" "$emoji_data" | rofi -dmenu -i \
      -theme-str "entry { placeholder: \" 🔎 Emoji\";} $rofi_position $r_override" \
      -theme-str "$font_override" \
      -theme "${style_type:-clipboard}" \
      -matching fuzzy -no-custom
    ;;
  esac
}

paste_string() {
  [[ "$paste_after_copy" == "1" ]] || return 0
  command -v wtype >/dev/null || return 0

  if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && command -v hyprctl >/dev/null; then
    hyprctl -q dispatch exec 'wtype -M ctrl V -m ctrl' >/dev/null 2>&1 || true
  else
    wtype -M ctrl V -m ctrl >/dev/null 2>&1 || true
  fi
}

main() {
  parse_args "$@"
  ensure_files
  setup_rofi_config

  local data_emoji selected_emoji_char
  data_emoji="$(run_rofi || true)"
  [[ -n "$data_emoji" ]] || exit 0

  selected_emoji_char="$(printf '%s' "$data_emoji" | cut -d' ' -f1 | xargs)"
  [[ -n "$selected_emoji_char" ]] || exit 0

  wl-copy "$selected_emoji_char"
  save_recent_entry "$data_emoji"
  paste_string
}

main "$@"
