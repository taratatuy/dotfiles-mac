local wezterm = require("wezterm")
local mux = wezterm.mux

local config = wezterm.config_builder()

config.term = "wezterm"
config.enable_tab_bar = false
config.window_background_opacity = 0.7
config.macos_window_background_blur = 40
config.font_size = 13
config.max_fps = 120
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.window_close_confirmation = "NeverPrompt"

config.default_prog = {
	"/bin/zsh",
	"--login",
	"-c",
	[[
  if command -v tmux >/dev/null 2>&1; then
    tmux attach || tmux new;
  else
    exec zsh;
  fi
]],
}

wezterm.on("gui-startup", function(window)
	local tab, pane, window = mux.spawn_window(cmd or {})
	local gui_window = window:gui_window()
	gui_window:maximize()
	gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)

return config
