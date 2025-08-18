# haskell
if gum confirm "Haskell anyone?"; then
  if ! command -v ghcup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    source ~/.bashrc
  fi
fi

if gum confirm "Algorave?"; then
  cabal install fourmolu
  cabal install tidal --lib
fi
