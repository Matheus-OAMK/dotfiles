#!/usr/bin/env bash
set -euo pipefail

# Optional: force install without prompts if the first argument is "force"
FORCE="${1:-}"

# Function for prompting yes/no
ask() {
  local prompt="$1"
  local default="${2:-y}"
  if [[ "$FORCE" == "force" ]]; then
    return 0
  fi
  read -rp "$prompt [y/n] (default $default): " answer
  answer="${answer:-$default}"
  [[ "$answer" =~ ^[Yy]$ ]]
}

# Bootstrap yay if not installed
if ! command -v yay &>/dev/null; then
  echo "⬇️ yay not found. Installing yay..."
  if ask "Install yay now?"; then
    sudo pacman -S --needed --noconfirm base-devel git
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    cd "$tmpdir/yay"
    makepkg -si --noconfirm
    cd -
    rm -rf "$tmpdir"
    echo "✅ yay installed."
  else
    echo "⚠️ yay not installed. AUR packages will be skipped."
  fi
fi

# List of packages to install via pacman (official repos)
PACMAN_PACKAGES=(
  base-devel
  unzip
  wget
  curl
  nano
  make
  cmake
  less
  git
  tree
  neovim
  tmux
  ripgrep
  fzf
  gwenview
  ark
  flatpak
  discover
  qps
  thunar
  nemo
  pavucontrol
  vlc
  vlc-plugins-all

  kitty
  nerd-fonts
  noto-fonts
  noto-fonts-emoji

  kwalletmanager

)

# List of AUR packages (via yay)
AUR_PACKAGES=(
  brave-bin
)

# Function to install pacman package if not installed
install_pacman() {
  local pkg="$1"
  if ! pacman -Qi "$pkg" &>/dev/null; then
    if ask "Install pacman package $pkg?"; then
      echo "⬇️ Installing $pkg via pacman..."
      sudo pacman -S --needed --noconfirm "$pkg"
    else
      echo "⏭ Skipping $pkg"
    fi
  else
    echo "✅ $pkg already installed"
  fi
}

# Function to install AUR package if not installed
install_aur() {
  local pkg="$1"
  if ! pacman -Qi "$pkg" &>/dev/null; then
    if ask "Install AUR package $pkg?"; then
      echo "⬇️ Installing $pkg via yay..."
      yay -S --needed --noconfirm "$pkg"
    else
      echo "⏭ Skipping $pkg"
    fi
  else
    echo "✅ $pkg already installed"
  fi
}

# Install pacman packages
for pkg in "${PACMAN_PACKAGES[@]}"; do
  install_pacman "$pkg"
done

# Install AUR packages
for pkg in "${AUR_PACKAGES[@]}"; do
  install_aur "$pkg"
done

echo "✅ All requested packages handled."
