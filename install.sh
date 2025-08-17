# yay
sudo pacman -S --needed git base-devel yay

# mostly everything
yay -S hyprland hyprshade nvim zed-preview waybar dunst hyprpaper ranger supercollider tofi zen-browser-bin wezterm-git hyprlock hypridle nicotine signal-desktop kitty pixterm-git chromium cpio qpwgraph github-cli dolphin lollypop 1password 

# ghc/haskell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

cabal install tidal fourmolu
