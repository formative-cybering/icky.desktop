#!/usr/bin/env bash
set -euo pipefail

# hyprctl notify -1 10000 0 "$(cat)"

(
  echo ":{"
    echo "tactus (\" $(cat | cut -d'"' -f2) \" :: Pattern String)"
  echo ":}"
  ) | wezterm cli send-text --pane-id $(cat "/tmp/WEZ_TIDAL")



text=$(wezterm cli get-text --pane-id $(cat "/tmp/WEZ_TIDAL") | grep "Just" | tail -1)

echo $text

