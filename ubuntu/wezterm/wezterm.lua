-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Dracula'
config.font = wezterm.font 'Fira Mono'
config.font_size = 14.0
config.window_background_opacity = 0.8

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- and finally, return the configuration to wezterm
return config
