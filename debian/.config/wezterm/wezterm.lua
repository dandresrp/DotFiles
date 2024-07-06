local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux

config.color_scheme = 'Dark+'
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.font_size = 16.0
config.enable_tab_bar = false

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

return config
