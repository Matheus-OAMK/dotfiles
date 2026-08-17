#!/usr/bin/env bash
set -euo pipefail

pkill -u "$USER" rofi 2>/dev/null && exit 0

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROFI_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/rofi"
mkdir -p "$ROFI_CACHE_HOME"

favorites_file="$ROFI_CACHE_HOME/cliphist_favorites"
cliphist_style="${ROFI_CLIPHIST_STYLE:-clipboard}"
font_scale="${ROFI_CLIPHIST_SCALE:-${ROFI_SCALE:-10}}"
font_name="${ROFI_CLIPHIST_FONT:-${ROFI_FONT:-JetBrainsMono Nerd Font}}"
paste_after_copy="${ROFI_CLIPHIST_PASTE:-1}"
ACTION=""

usage() {
  cat <<EOF
$(basename "$0") [options]

Options:
  -c, --copy             Show clipboard history and copy selected item
  -d, --delete           Delete selected clipboard item(s)
  -f, --favorites        View favorite clipboard items
  -m, --manage-fav       Manage favorites
  -w, --wipe             Clear clipboard history
  -i, --image-history    Show image clipboard history
  -s, --scan-image       OCR latest image in clipboard history
      --style THEME      Rofi theme/style, fallback: clipboard
      --no-paste         Copy only, do not paste with wtype
      --paste            Copy and paste with wtype (default)
  -h, --help             Show help

Environment:
  ROFI_CLIPHIST_STYLE    Rofi theme/style, fallback: clipboard
  ROFI_CLIPHIST_FONT     Font name
  ROFI_CLIPHIST_SCALE    Font size, fallback: ROFI_SCALE or 10
EOF
}

parse_args() {
  while (($# > 0)); do
    case "$1" in
      -c|--copy) ACTION="copy" ;;
      -d|--delete) ACTION="delete" ;;
      -f|--favorites) ACTION="favorites" ;;
      -m|--manage-fav) ACTION="manage_fav" ;;
      -w|--wipe) ACTION="wipe" ;;
      -i|--image-history) ACTION="image_history" ;;
      -s|--scan-image) ACTION="ocr_image" ;;
      --style)
        [[ $# -gt 1 ]] || { echo "--style needs THEME" >&2; exit 1; }
        cliphist_style="$2"
        shift
        ;;
      --no-paste) paste_after_copy=0 ;;
      --paste) paste_after_copy=1 ;;
      -h|--help)
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

need_cmds() {
  local missing=()
  for cmd in rofi cliphist wl-copy; do
    command -v "$cmd" >/dev/null || missing+=("$cmd")
  done
  if ((${#missing[@]})); then
    printf 'Missing command(s): %s\n' "${missing[*]}" >&2
    exit 1
  fi
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
  r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;}wallbox{border-radius:${elem_border}px;}element{border-radius:${elem_border}px;}"
}

run_rofi() {
  local placeholder="$1"
  shift
  rofi -dmenu \
    -theme-str "entry { placeholder: \"$placeholder\";}" \
    -theme-str "$font_override" \
    -theme-str "$r_override" \
    -theme-str "$rofi_position" \
    -theme "$cliphist_style" \
    -kb-custom-1 "Alt+c" \
    -kb-custom-2 "Alt+d" \
    -kb-custom-3 "Alt+n" \
    -kb-custom-4 "Alt+w" \
    -kb-custom-5 "Alt+o" \
    -kb-custom-6 "Alt+v" \
    -kb-custom-7 "Alt+s" \
    "$@"
  local exit_code=$?
  if ((exit_code != 0)); then
    case "$exit_code" in
      10) printf ':c:o:p:y:' ;;
      11) printf ':d:e:l:e:t:e:' ;;
      12) printf ':f:a:v:' ;;
      13) printf ':w:i:p:e:' ;;
      14) printf ':o:p:t:' ;;
      15) printf ':i:m:g:' ;;
      16) printf ':o:c:r:' ;;
    esac
  fi
}

notify() {
  if command -v notify-send >/dev/null; then
    notify-send "$@" >/dev/null 2>&1 || true
  fi
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

handle_special_commands() {
  local first="${1:-}"
  case "$first" in
    ':d:e:l:e:t:e:'*) exec "$0" --delete ;;
    ':w:i:p:e:'*) exec "$0" --wipe ;;
    ':b:a:r:'*|*':c:o:p:y:'*) exec "$0" --copy ;;
    ':f:a:v:'*) exec "$0" --favorites ;;
    ':i:m:g:'*) exec "$0" --image-history ;;
    ':o:p:t:'*) exec "$0" ;;
    ':o:c:r:'*) exec "$0" --scan-image ;;
  esac
}

process_selections() {
  mapfile -t lines
  ((${#lines[@]})) || return 1
  handle_special_commands "${lines[@]}"

  local output="" line decoded_line i
  for ((i = 0; i < ${#lines[@]}; i++)); do
    line="${lines[$i]}"
    decoded_line="$(printf '%s\t' "$line" | cliphist decode)"
    if ((i < ${#lines[@]} - 1)); then
      output+="$decoded_line"$'\n'
    else
      output+="$decoded_line"
    fi
  done
  printf '%s' "$output"
}

check_binary_content() {
  local line
  read -r line || return 0
  if [[ "$line" == *"[[ binary data"* ]]; then
    cliphist decode <<<"$line" | wl-copy
    notify "Clipboard" "Copied binary/image data"
    return 1
  fi
  printf '%s\n' "$line"
  cat
}

cliphist_cmd() {
  if [[ "${CLIPHIST_IMAGE_HISTORY:-}" != true ]]; then
    printf ':f:a:v:\t📌 Favorites\n'
    printf ':o:p:t:\t⚙️ Options\n'
    cliphist list
  else
    if [[ -x "$SCRIPT_DIR/cliphist.image.py" ]]; then
      HYDE_CLIPHIST_IMAGE_ONLY=true "$SCRIPT_DIR/cliphist.image.py"
    else
      cliphist list | grep '\[\[ binary data' || true
    fi
  fi
}

show_history() {
  local selected_item rofi_args=()
  rofi_args=(" 📜 History..." -multi-select -i -display-columns 2 -selected-row 2)

  if [[ "${CLIPHIST_IMAGE_HISTORY:-}" == true ]]; then
    rofi_args=(" 🏞️ Image History | Alt+S to Scan" -display-columns 2 -show-icons -eh 3 \
      -theme-str 'listview { lines: 4; columns: 2; }' \
      -theme-str 'element { enabled: true; orientation: vertical; spacing: 0%; padding: 0%; cursor: pointer; background-color: transparent; text-color: @main-fg; horizontal-align: 0.5; }' \
      -theme-str 'element-text { enabled: false;}' \
      -theme-str 'element-icon {size: 8%; spacing: 0%; padding: 0%; cursor: inherit; background-color: transparent; }' \
      -theme-str 'element selected.normal { background-color: @select-bg; text-color: @select-fg; }')
  fi

  selected_item="$(cliphist_cmd | run_rofi "${rofi_args[@]}" || true)"
  [[ -n "$selected_item" ]] || exit 0
  handle_special_commands "${selected_item##*$'\n'}"

  if printf '%s\n' "$selected_item" | check_binary_content >/tmp/cliphist-custom-selection.$$; then
    process_selections </tmp/cliphist-custom-selection.$$ | wl-copy
    rm -f /tmp/cliphist-custom-selection.$$
    paste_string
    printf '%s\t' "$selected_item" | cliphist delete || true
  else
    rm -f /tmp/cliphist-custom-selection.$$
    paste_string
  fi
}

process_deletion() {
  while IFS= read -r line; do
    [[ -n "$line" ]] || continue
    handle_special_commands "$line"
    cliphist delete <<<"$line"
    notify "Deleted" "$line"
  done
}

delete_items() {
  local selected_item
  selected_item="$(cliphist list | run_rofi " 🗑️ Delete" -multi-select -i -display-columns 2 || true)"
  [[ -n "$selected_item" ]] || exit 0
  handle_special_commands "${selected_item##*$'\n'}"
  process_deletion <<<"$selected_item"
}

ensure_favorites_dir() {
  mkdir -p "$(dirname "$favorites_file")"
}

prepare_favorites_for_display() {
  [[ -s "$favorites_file" ]] || return 1
  mapfile -t favorites <"$favorites_file"
  decoded_lines=()
  local favorite decoded_favorite single_line_favorite
  for favorite in "${favorites[@]}"; do
    decoded_favorite="$(base64 --decode <<<"$favorite")"
    single_line_favorite="$(tr '\n' ' ' <<<"$decoded_favorite")"
    decoded_lines+=("$single_line_favorite")
  done
}

view_favorites() {
  prepare_favorites_for_display || { notify "Clipboard" "No favorites."; return; }
  local selected_item index selected_encoded_favorite
  selected_item="$(printf '%s\n' "${decoded_lines[@]}" | run_rofi "📌 View Favorites" || true)"
  [[ -n "$selected_item" ]] || exit 0
  handle_special_commands "${selected_item##*$'\n'}"

  index="$(printf '%s\n' "${decoded_lines[@]}" | grep -nxF "$selected_item" | cut -d: -f1)"
  [[ -n "$index" ]] || { notify "Clipboard" "Selected favorite not found."; return; }
  selected_encoded_favorite="${favorites[$((index - 1))]}"
  base64 --decode <<<"$selected_encoded_favorite" | wl-copy
  paste_string
  notify "Clipboard" "Copied favorite."
}

add_to_favorites() {
  ensure_favorites_dir
  local item full_item encoded_item
  item="$(cliphist list | run_rofi "➕ Add to Favorites..." || true)"
  [[ -n "$item" ]] || exit 0
  full_item="$(cliphist decode <<<"$item")"
  encoded_item="$(printf '%s' "$full_item" | base64 -w 0)"
  if [[ -f "$favorites_file" ]] && grep -Fxq "$encoded_item" "$favorites_file"; then
    notify "Clipboard" "Item already in favorites."
  else
    printf '%s\n' "$encoded_item" >>"$favorites_file"
    notify "Clipboard" "Added to favorites."
  fi
}

delete_from_favorites() {
  prepare_favorites_for_display || { notify "Clipboard" "No favorites to remove."; return; }
  local selected_favorite index selected_encoded_favorite tmp
  selected_favorite="$(printf '%s\n' "${decoded_lines[@]}" | run_rofi "➖ Remove from Favorites..." || true)"
  [[ -n "$selected_favorite" ]] || exit 0
  index="$(printf '%s\n' "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)"
  [[ -n "$index" ]] || { notify "Clipboard" "Selected favorite not found."; return; }
  selected_encoded_favorite="${favorites[$((index - 1))]}"
  tmp="$(mktemp)"
  grep -vF -x "$selected_encoded_favorite" "$favorites_file" >"$tmp" || true
  mv "$tmp" "$favorites_file"
  notify "Clipboard" "Favorite removed."
}

clear_favorites() {
  if [[ -s "$favorites_file" ]]; then
    local confirm
    confirm="$(printf 'Yes\nNo\n' | run_rofi "☢️ Clear All Favorites?" || true)"
    [[ "$confirm" == "Yes" ]] || return 0
    : >"$favorites_file"
    notify "Clipboard" "Favorites cleared."
  else
    notify "Clipboard" "No favorites to delete."
  fi
}

manage_favorites() {
  local manage_action
  manage_action="$(printf 'Add to Favorites\nDelete from Favorites\nClear All Favorites\n' | run_rofi "📓 Manage Favorites" || true)"
  case "$manage_action" in
    'Add to Favorites') add_to_favorites ;;
    'Delete from Favorites') delete_from_favorites ;;
    'Clear All Favorites') clear_favorites ;;
    '') return 0 ;;
    *) echo "Invalid action: $manage_action" >&2; exit 1 ;;
  esac
}

clear_history() {
  local selected_item
  selected_item="$(printf 'Yes\nNo\n' | run_rofi "☢️ Clear Clipboard History?" || true)"
  handle_special_commands "${selected_item##*$'\n'}"
  if [[ "$selected_item" == "Yes" ]]; then
    cliphist wipe
    notify "Clipboard" "Clipboard history cleared."
  fi
}

main_menu_options() {
  cat <<EOF
History:::<sub>(Alt+C)</sub>
Image History:::<sub>(Alt+V)</sub>
Delete Item:::<sub>(Alt+D)</sub>
Clear History:::<sub>(Alt+W)</sub>
View Favorites:::<sub>(Alt+N)</sub>
Manage Favorites:::<sub>(Alt+O)</sub>
EOF
}

ocr_scan() {
  command -v tesseract >/dev/null || { notify "OCR Error" "tesseract not installed"; exit 1; }
  local runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$EUID}/rofi"
  local image_path="$runtime_dir/cliphist_ocr.png"
  local index
  mkdir -p "$runtime_dir"
  index="$(cliphist list | grep '\[\[ binary data' | head -n1 || true)"
  [[ -n "$index" ]] || { notify "OCR Error" "No images in clipboard history."; exit 1; }
  cliphist decode <<<"$index" >"$image_path"
  [[ -s "$image_path" ]] || { notify "OCR Error" "No image data."; exit 1; }
  notify "OCR" "Scanning latest clipboard image..."
  tesseract "$image_path" stdout | wl-copy
  paste_string
  notify "OCR" "Copied extracted text."
}

main() {
  parse_args "$@"
  need_cmds
  setup_rofi_config

  if [[ -z "$ACTION" ]]; then
    local main_action
    main_action="$(main_menu_options | run_rofi "🔎 Options (Alt O)" \
      -display-column-separator ":::" \
      -display-columns 1,2 \
      -markup-rows || true)"
    handle_special_commands "${main_action##*$'\n'}"
    main_action="${main_action%%:::*}"
    case "$main_action" in
      'History') ACTION="copy" ;;
      'Image History') ACTION="image_history" ;;
      'Delete Item') ACTION="delete" ;;
      'Clear History') ACTION="wipe" ;;
      'View Favorites') ACTION="favorites" ;;
      'Manage Favorites') ACTION="manage_fav" ;;
      *) exit 0 ;;
    esac
  fi

  case "$ACTION" in
    copy) show_history ;;
    delete) delete_items ;;
    favorites) view_favorites ;;
    manage_fav) manage_favorites ;;
    wipe) clear_history ;;
    image_history) CLIPHIST_IMAGE_HISTORY=true show_history ;;
    ocr_image) ocr_scan ;;
    *) usage >&2; exit 1 ;;
  esac
}

main "$@"
