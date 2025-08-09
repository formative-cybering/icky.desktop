#!/usr/bin/env bash
set -euo pipefail

hyprshade on invert

(
  echo ":{"
  cat
  echo ":}"
) | wezterm cli send-text --pane-id $(cat "/tmp/WEZ_TIDAL")

sleep 0.1

hyprshade off
