local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'rose-pine'

config.font = wezterm.font_with_fallback {
	'FiraCode Nerd Font',
	'JetBrainsMono Nerd Font',
	'CaskaydiaCove Nerd Font',
	'UbuntuMono Nerd Font',
}
config.font_size = 12.0

config.enable_tab_bar = false

config.window_background_opacity = 1.0

return config
