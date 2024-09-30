local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	{
		family = "Monaspace Neon",
		harfbuzz_features = { "calt", "liga", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "ss09" },
	},
	"MesloLGS NF",
})

config.font_size = 13.0

config.color_scheme = "Catppuccin Mocha"

-- config.window_background_opacity = 0.85

config.audible_bell = "Disabled"

config.tab_bar_at_bottom = true

config.hide_tab_bar_if_only_one_tab = true

config.window_frame = {}

config.use_fancy_tab_bar = true

config.window_decorations = "RESIZE"

config.window_close_confirmation = "NeverPrompt"

config.keys = {
	{
		key = "p",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
}

return config

