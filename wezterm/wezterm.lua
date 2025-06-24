-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

local set_environment_variables = {
	PATH = wezterm.home_dir .. "/usr/bin:" .. os.getenv("PATH"),
}

-- This will hold the configuration.
local config = wezterm.config_builder()

--config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.enable_wayland = true
config.font_size = 15
config.window_background_opacity = 0.825
config.color_scheme = "Oxocarbon Dark (Gogh)"

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.keys = {
	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
}

-- and finally, return the configuration to wezterm
return config
