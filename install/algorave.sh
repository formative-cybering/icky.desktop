#!/usr/bin/env bash

set -euo pipefail

if gum confirm "👾 Algorave?"; then
  if ! command -v ghcup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh
    source "$HOME/.ghcup/env"
  fi

  yay -S --needed --noconfirm supercollider qpwgraph

  version=$(git ls-remote https://github.com/musikinformatik/SuperDirt.git | grep tags | tail -n1 | awk -F/ '{print $NF}'); echo 'Quarks.install("https://github.com/musikinformatik/SuperDirt.git", "tags/'$version'"); 0.exit;' > /tmp/sd.scd && sclang /tmp/sd.scd

  if ! command -v fourmolu &>/dev/null; then
    cabal install fourmolu
  fi

  if ! ghc-pkg list tidal | grep tidal &>/dev/null; then
    cabal install tidal --lib
  fi
fi
