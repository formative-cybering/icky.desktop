#!/usr/bin/env bash

set -euo pipefail

# Fonts
sudo cp ./fonts/boxcutter.ttf /usr/share/fonts/boxcutter.ttf
sudo cp ./fonts/programma.otf /usr/share/fonts/programma.otf
sudo fc-cache -fv

# Install yay
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay
  makepkg -si --noconfirm
  popd
  rm -rf /tmp/yay
fi

# Mostly everything
main_packages=(
  hyprland
  hyprshade
  hyprpaper
  waybar
  dunst
  hyprlock
  hypridle

  nvim
  wezterm-git
  kitty
  ranger
  zed-preview
  stylua
  go

  zen-browser-bin
  chromium
  signal-desktop
  nicotine

  supercollider
  qpwgraph
  lollypop

  github-cli
  dolphin
  cpio
  pixterm-git
  1password
  ttf-nerd-fonts-symbols
)

yes | yay -S "${main_packages[@]}"


# Haskell toolchain setup
if ! command -v ghcup &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
fi

# Haskell packages
if command -v cabal &>/dev/null; then
  cabal install tidal fourmolu
fi

# Deno
if ! command -v deno &>/dev/null; then
  curl -fsSL https://deno.land/install.sh | sh
fi

echo "💦 Done"
