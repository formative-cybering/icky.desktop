-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

config.front_end = "WebGpu"
config.enable_wayland = true
config.font_size = 16

config.color_scheme = 'Oxocarbon Dark (Gogh)'

config.keys = {
  { key = "c",
    mods = "CTRL",
    action = act.CopyTo 'Clipboard'
  },
  { key = "v",
    mods = "CTRL",
    action = act.PasteFrom 'Clipboard'
  }
}


-- and finally, return the configuration to wezterm
return config
