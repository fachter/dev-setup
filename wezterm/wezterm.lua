local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

config.font = wezterm.font({
	family = "JetBrains Mono",
	weight = "Medium",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" }, -- disable ligatures
})
config.font_size = 11.0
config.line_height = 1.0
-- (here will be added actual configuration)

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Macchiato"
	else
		return "Catppuccin Latte"
	end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.window_padding = { left = "0.5cell", right = "0.5cell", top = "0.5cell", bottom = "0.5cell" }
config.default_cursor_style = "BlinkingBar"
-- config.default_prog = { "/bin/zsh", "-l", "-c", "tmux attach || tmux" }
config.scrollback_lines = 20000

config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
config.window_background_opacity = 0.96
config.macos_window_background_blur = 20

-- https://github.com/wez/wezterm/issues/3299#issuecomment-2145712082
wezterm.on("gui-startup", function(cmd)
	local active = wezterm.gui.screens().active
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:guiwindow():setposition(active.x, active.y)
	window:guiwindow():set_innersize(active.width, active.height)
end)

config.keys = {
	{ key = "d", mods = "CMD|SHIFT", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "k", mods = "CMD", action = action.ClearScrollback("ScrollbackAndViewport") },
	{ key = "w", mods = "CMD", action = action.CloseCurrentPane({ confirm = false }) },
	{ key = "w", mods = "CMD|SHIFT", action = action.CloseCurrentTab({ confirm = false }) },
	{ key = "LeftArrow", mods = "CMD", action = action.SendKey({ key = "Home" }) },
	{ key = "RightArrow", mods = "CMD", action = action.SendKey({ key = "End" }) },
	{ key = "p", mods = "CMD|SHIFT", action = action.ActivateCommandPalette },
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action.SendString("\x1bb") },
	{ key = "RightArrow", mods = "OPT", action = wezterm.action.SendString("\x1bf") },
	{ key = "Enter", mods = "CTRL", action = wezterm.action.SendString("\x1b[27;5;13~") }, -- Ctrl+Enter to send \e[27;5;13~ (Ctrl+Enter) to terminal
}

return config
