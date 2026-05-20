#!/usr/bin/env bash
set -euo pipefail

# Optional: install without per-package prompts with "force" or "--force".
FORCE=""
REQUESTED_GROUPS=()

usage() {
  cat <<'EOF'
Usage: ./packages.sh [force|--force] [GROUP...]

Groups:
  ui            Install PACKAGES_UI
  dev           Install PACKAGES_DEV
  applications  Install PACKAGES_APPLICATIONS
  all           Install every package group

Examples:
  ./packages.sh ui dev
  ./packages.sh --force all
EOF
}

for arg in "$@"; do
  case "$arg" in
  force | --force)
    FORCE="force"
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  ui | dev | applications | all)
    REQUESTED_GROUPS+=("$arg")
    ;;
  *)
    echo "Unknown option or group: $arg" >&2
    usage >&2
    exit 1
    ;;
  esac
done

if ! command -v paru &>/dev/null; then
  cat >&2 <<'EOF'
paru was not found.

Install paru first, then re-run this script. See rice.md for the bootstrap notes.
EOF
  exit 1
fi

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

install_package() {
  local pkg="$1"

  if pacman -Qi "$pkg" &>/dev/null; then
    echo "✅ $pkg already installed"
    return 0
  fi

  if ask "Install package $pkg?"; then
    echo "⬇️ Installing $pkg via paru..."
    paru -S --needed --noconfirm "$pkg"
  else
    echo "⏭ Skipping $pkg"
  fi
}

install_group() {
  local group_name="$1"
  shift
  local packages=("$@")

  echo "==> Installing $group_name"
  for pkg in "${packages[@]}"; do
    install_package "$pkg"
  done
}

PACKAGES_UI=(
  hyprland

  kitty     # Terminal
  tmux      # Terminal multiplexer
  fastfetch # Sys info on terminal

  qt5-wayland
  qt6-wayland

  # Fonts
  noto-fonts
  noto-fonts-emoji
  nerd-fonts
  ttf-rubik-vf

  # Screenshare and filepicker
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk

  hyprpolkitagent # elevate priveleges
  hyprshutdown    # To gracefully shutdown hyprland

  hyprshot           # Capture screenshots
  satty              # Annotate screenshots
  tesseract          # OCR CLI (For screenshot text extraction)
  tesseract-data-eng # OCR CLI (For screenshot text extraction)

  wl-clipboard    # clipboard
  cliphist        # Clipboard history
  wl-clip-persist # To fix clipboard when apps die

  sddm              # Login
  sddm-silent-theme # SDDM theme
  rofi              # App launcher
  waybar            # A bar
  hyprpicker        # Colour picker
  awww              # Wallpaper daemon
  matugen-bin       # Color extractor for wallpaper
  imagemagick       # CLI util for manupulating images
  pavucontrol       # Volume controlcenter
  networkmanager    # For network and nmtui
  wlogout           # Logout screen
  nwg-look          # To configure gtk

  # Icons theme
  tela-circle-icon-theme-all
  papirus-icon-theme

  swaync    # notification UI
  libnotify # CLI for notifications

  # Keyring stuff
  gnome-keyring
  libsecret
  seahorse     # GUI to view and manage secrets
  lssecret-git # lssecret command to print secrets uilised by keyring
  gcr          # ssh-agent that automatically unlocks ssh key

  nautilus        # File explorer
  nautilus-python # To open in terminal (requires adding the script)
  file-roller     # For file extraction

  mpv   # Video player
  loupe # Image viewer

  trash-cli # Easier command for bin

)

PACKAGES_DEV=(
  base-devel
  cmake
  git
  openssh
  less
  btop
  wget
  curl
  unzip

  # Text Editor
  neovim
  tree-sitter-cli # Needed for neovim
  vim
  nano

  # Terminal
  zsh
  zsh-autosuggestions     # Auto suggestions for shell commands based on history
  zsh-completions         # Commands auto completions
  zsh-syntax-highlighting # highlights commands
  eza                     # ls alternative with colorss
  bat                     # Alternative to cat, with syntax highlighting
  starship                # terminal prompt

  # Terminal CLI tools
  fzf     # fuzzy finder
  fd      # Better find
  ripgrep # better grep
  tree
  jq       # CLI json parser
  tealdeer # tldr command
  lazygit  # git TUI
  rsync

  fnm # Node version manager
  uv  # Python version manager / packages/ all batteries included

  # Docker

  docker
  docker-compose
  lazydocker

)

PACKAGES_APPLICATIONS=(
  brave-bin      # Browser
  vesktop        # Discord
  betterbird-bin # Email client
  tidal-hifi-bin # Music
  flatpak        # To isolate packages
)

FLATPAK_APPLICATIONS=(
  com.stremio.Stremio # Stremio
)

install_flatpak_applications() {
  if ! command -v flatpak &>/dev/null; then
    echo "flatpak was not found. Install the applications group first." >&2
    return 1
  fi

  echo "==> Installing FLATPAK_APPLICATIONS"
  for app in "${FLATPAK_APPLICATIONS[@]}"; do
    if flatpak info "$app" &>/dev/null; then
      echo "✅ $app already installed"
      continue
    fi

    if ask "Install Flatpak app $app?"; then
      echo "⬇️ Installing $app via flatpak..."
      flatpak install -y flathub "$app"
    else
      echo "⏭ Skipping $app"
    fi
  done
}

if [[ " ${REQUESTED_GROUPS[*]} " == *" all "* ]]; then
  REQUESTED_GROUPS=(ui dev applications)
fi

if ((${#REQUESTED_GROUPS[@]} == 0)); then
  usage
  exit 0
fi

for group in "${REQUESTED_GROUPS[@]}"; do
  case "$group" in
  ui)
    install_group "PACKAGES_UI" "${PACKAGES_UI[@]}"
    ;;
  dev)
    install_group "PACKAGES_DEV" "${PACKAGES_DEV[@]}"
    ;;
  applications)
    install_group "PACKAGES_APPLICATIONS" "${PACKAGES_APPLICATIONS[@]}"
    install_flatpak_applications
    ;;
  esac
done

echo "✅ All requested packages handled."
