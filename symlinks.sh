#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "📂 Dotfiles repo: $REPO_DIR"
echo "📂 Target config: $CONFIG_DIR"

# Function to ask yes/no question
ask() {
  local prompt="$1"
  local default="${2:-y}" # default is yes
  read -rp "$prompt [y/n] (default $default): " answer
  answer="${answer:-$default}"
  [[ "$answer" =~ ^[Yy]$ ]]
}

# Find all directories directly under ./config
configs=$(find "$REPO_DIR/config" -mindepth 1 -maxdepth 1 -type d)

for src in $configs; do
  name=$(basename "$src")
  dest="$CONFIG_DIR/$name"

  # Skip if source is not a directory
  if [ ! -d "$src" ]; then
    echo "⚠️  Skipping $name (not a directory)"
    continue
  fi

  # Handle existing destination
  if [ -L "$dest" ] || [ -d "$dest" ] || [ -f "$dest" ]; then
    echo "⚠️  Config $dest already exists."

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
      continue
    fi
  fi

  # Create symlink
  echo "🔗 Linking $dest -> $src"
  ln -s "$src" "$dest"
done

echo "✅ Done! All configs from $REPO_DIR/config are linked safely."
