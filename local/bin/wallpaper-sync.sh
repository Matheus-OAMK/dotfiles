#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s <image-path>\n' "$(basename "$0")"
}

if [ "${1-}" = "-h" ] || [ "${1-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -ne 1 ]; then
  usage >&2
  exit 1
fi

image="$1"
case "$image" in
"~") image="$HOME" ;;
"~/"*) image="$HOME/${image#~/}" ;;
esac

if [ ! -f "$image" ]; then
  printf 'Error: image not found: %s\n' "$image" >&2
  exit 1
fi

for cmd in magick matugen; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'Error: required command not found: %s\n' "$cmd" >&2
    exit 1
  fi
done

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper"
thmb_path="$cache_dir/wall.thmb"
blur_path="$cache_dir/wall.blur"
sqre_path="$cache_dir/wall.sqre"
quad_path="$cache_dir/wall.quad"

mkdir -p "$cache_dir"

magick "${image}[0]" -strip -resize 1000 -gravity center -extent 1000 -quality 90 "$thmb_path"
magick "${image}[0]" -strip -scale 10% -blur 0x3 -resize 100% "$blur_path"
magick "${image}[0]" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "$sqre_path"
magick "$sqre_path" \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha off -compose CopyOpacity -composite "$quad_path"

matugen image "$image"

printf 'Generated %s\n' "$thmb_path"
printf 'Generated %s\n' "$blur_path"
printf 'Ran matugen for %s\n' "$image"
