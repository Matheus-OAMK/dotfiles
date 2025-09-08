#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
PICTURES_DIR="$HOME/Pictures"

echo "📂 Dotfiles repo: $REPO_DIR"
echo "📂 Target config: $CONFIG_DIR"
echo "🖼️  Target pictures: $PICTURES_DIR"

# Function to ask yes/no question
ask() {
  local prompt="$1"
  local default="${2:-y}" # default is yes
  read -rp "$prompt [y/n] (default $default): " answer
  answer="${answer:-$default}"
  [[ "$answer" =~ ^[Yy]$ ]]
}

link_item() {
  local src="$1"
  local dest="$2"

  # Handle existing destination
  if [ -L "$dest" ] || [ -d "$dest" ] || [ -f "$dest" ]; then
    echo "⚠️  $dest already exists."

    if ask "Do you want to override it?"; then
      if [ -L "$dest" ]; then
        echo "🔄 Removing existing symlink $dest"
        rm "$dest"
      else
        bak="$dest.bak_$(date +%Y%m%d%H%M%S)"
        echo "💾 Backing up $dest -> $bak"
        mv "$dest" "$bak"
      fi
    else
      echo "⏭️  Skipping $dest"
      return
    fi
  fi

  # Create symlink
  echo "🔗 Linking $dest -> $src"
  ln -s "$src" "$dest"
}

# ==============================
# Link config files & folders
# ==============================
configs=$(find "$REPO_DIR/config" -mindepth 1 -maxdepth 1)

for src in $configs; do
  name=$(basename "$src")
  dest="$CONFIG_DIR/$name"
  link_item "$src" "$dest"
done

# ==============================
# Link assets to ~/Pictures
# ==============================
if [ -d "$REPO_DIR/assets" ]; then
  assets=$(find "$REPO_DIR/assets" -mindepth 1 -maxdepth 1 -type d)
  for src in $assets; do
    name=$(basename "$src")
    dest="$PICTURES_DIR/$name"
    link_item "$src" "$dest"
  done
fi

echo "✅ Done! Configs and assets are linked safely."
