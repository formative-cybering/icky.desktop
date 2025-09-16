#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay
  makepkg -si --noconfirm
  popd
  rm -rf /tmp/yay
fi

if ! command -v gum &>/dev/null; then
  yay -S gum
fi

if gum confirm "📝 Fonts?"; then
  sudo mkdir -p /usr/share/fonts/
  sudo cp "$SCRIPT_DIR/../fonts/boxcutter.ttf" /usr/share/fonts/boxcutter.ttf
  sudo cp "$SCRIPT_DIR/../fonts/programma.otf" /usr/share/fonts/programma.otf
  yay -S --noconfirm --needed ttf-font-awesome ttf-cascadia-mono-nerd noto-fonts noto-fonts-emoji
fi

if gum confirm "👨‍🍳 Core?"; then
  core_packages=(
    hyprland
    hyprshade
    hyprpaper
    hyprlock
    hypridle
    rose-pine-hyprcursor

    tofi
    dunst
    waybar
    wl-clipboard
    slurp
    grim

    nvim
    helix
    wezterm-git
    kitty
    nnn
    zed
    fzf

    zen-browser-bin
    chromium

    ffmpeg
    imagemagick
    libsixel

    kvantum-qt5
    hyprqt6engine
    gnome-themes-extra
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    gnome-keyring
    polkit-gnome
    file-roller
    nemo
    cpio
    geary
    imv
    evince
  )
  yay -S --needed --noconfirm "${core_packages[@]}"

  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
fi

if gum confirm "👨‍🍳 More?"; then
  extra_packages=(
    go
    deno
    nodejs
    pnpm
    github-cli
    stylua

    signal-desktop

    lollypop
    reaper
    tenacity
    nicotine
    kid3

    obs-studio
    mpv
    handbrake
    p7zip
    pixterm-git
    less

    1password
  )
  yay -S --needed --noconfirm "${extra_packages[@]}"
fi

echo "💦 Done"
