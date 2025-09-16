-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

local set_environment_variables = {
	PATH = wezterm.home_dir .. "/usr/bin:" .. os.getenv("PATH"),
}

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("Programma")
config.font_dirs = { "/usr/share/fonts" }
config.warn_about_missing_glyphs = false

--config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.enable_wayland = true
config.font_size = 15
config.window_background_opacity = 0.7
config.enable_tab_bar = false
config.color_scheme = "Tomorrow Night Burns"

config.keys = {
	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
}

-- and finally, return the configuration to wezterm
return config
