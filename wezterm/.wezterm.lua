-- wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- config table
local config = {}

-- config_builder available in newer versions of wezterm
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Config

config.color_scheme = "Tokyo Night Moon"

-- Key mappings

config.keys = {
    {
        key = "g",
        mods = "CMD",
        action = act.ShowLauncher,
    },
    -- pane create/remove
    {
	key = "m",
	mods = "CMD",
	action = act.SplitPane {
	    direction = 'Right',
	    size = { Percent = 25 },
	},
    },
    {
	key = "u",
	mods = "CMD",
	action = act.SplitPane {
	    direction = 'Down',
	    size = { Percent = 30 },
	},
    },
    {
	key = "y",
	mods = "CMD",
	action = wezterm.action.CloseCurrentPane { confirm = true },
    },

    -- pane resizing
    {
        key = 'LeftArrow',
	mods = "CMD",
	action = act.AdjustPaneSize { 'Left', 5 },
    },
    {
        key = 'RightArrow',
	mods = "CMD",
	action = act.AdjustPaneSize { 'Right', 5 },
    },
    {
        key = 'UpArrow',
	mods = "CMD",
	action = act.AdjustPaneSize { 'Up', 5 },
    },
    {
        key = 'DownArrow',
	mods = "CMD",
	action = act.AdjustPaneSize { 'Down', 5 },
    },
    -- pane navigation
    {
        key = 'l',
	mods = "CMD",
	action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'h',
	mods = "CMD",
	action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'j',
	mods = "CMD",
	action = act.ActivatePaneDirection 'Down',
    },
    {
        key = 'k',
	mods = "CMD",
	action = act.ActivatePaneDirection 'Up',
    },
}

-- Launch menu

config.launch_menu = {
    {
        args = { "top" },
    },
    {
        label = "Bash",
        args = { "bash", "-l" },
    },
}

-- return configuration to wezterm
return config
