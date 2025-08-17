#!/usr/bin/env bash

set -euo pipefail

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
  sudo cp ./fonts/boxcutter.ttf /usr/share/fonts/boxcutter.ttf
  sudo cp ./fonts/programma.otf /usr/share/fonts/programma.otf
fi

# mostly everything
if gum confirm "Do you want to install mostly everything?"; then
  main_packages=(
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

    nvim
    wezterm-git
    kitty
    ranger-git
    zed-preview
    stylua
    go
    deno

    zen-browser-bin
    chromium
    signal-desktop
    nicotine

    supercollider
    qpwgraph
    lollypop
    obs-studio
    reaper
    tenacity

    github-cli
    dolphin
    cpio
    pixterm-git
    1password
    ttf-nerd-fonts-symbols
    libsixel
    mpv
    ffmpeg
    handbrake
    p7zip
  )
  yes | yay -S --needed "${main_packages[@]}"
fi

hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprfocus

# haskell
if gum confirm "Haskell anyone?"; then
  if ! command -v ghcup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    source ~/.bashrc
  fi
  cabal install fourmolu
  cabal install tidal --lib
fi

echo "💦 Done"
