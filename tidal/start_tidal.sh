#!/usr/bin/env bash
set -euo pipefail

tmp="/tmp/WEZ_TIDAL"
> $tmp

wezterm cli spawn -- sclang

WEZ_TIDAL=$(wezterm cli spawn -- ghci -ghci-script ~/.config/tidal/bootTidal.hs)

echo $WEZ_TIDAL > $tmp

wezterm cli activate-tab --tab-index 0

# wezterm cli split-pane --cells 10 -- cava

cd ~/code/bin

nvim .
