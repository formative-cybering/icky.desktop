#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# yay
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay
  makepkg -si --noconfirm
  popd
  rm -rf /tmp/yay
fi

# gum
if ! command -v gum &>/dev/null; then
  yay -S gum
fi

# fonts
if gum confirm "Copy fonts?"; then
  sudo mkdir -p /usr/share/fonts/
  sudo cp "$SCRIPT_DIR/../fonts/boxcutter.ttf" /usr/share/fonts/boxcutter.ttf
  sudo cp "$SCRIPT_DIR/../fonts/programma.otf" /usr/share/fonts/programma.otf
fi

if gum confirm "Install core?"; then
  core_packages=(
    hyprland
    hyprshade
    hyprpaper
    hyprlock
    hypridle
    tofi
    dunst
    waybar
    wl-clipboard
    slurp
    grim
    rose-pine-hyprcursor
    nvim
    wezterm-git
    ranger-git
    zen-browser-bin
    chromium
    xdg-desktop-portal
    libsixel
    qt6ct
  )
  yay -S --needed --noconfirm "${core_packages[@]}"
fi

if gum confirm "Install extra?"; then
  extra_packages=(
    kitty
    stylua
    go
    deno
    nodejs
    pnpm
    signal-desktop
    nicotine
    supercollider
    qpwgraph
    lollypop
    obs-studio
    reaper
    tenacity
    ffmpeg
    github-cli
    dolphin
    cpio
    pixterm-git
    1password
    mpv
    handbrake
    p7zip
  )
  yay -S --needed --noconfirm "${extra_packages[@]}"
fi

echo "💦 Done"
