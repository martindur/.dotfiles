-- wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- config table
local config = {}

-- config_builder available in newer versions of wezterm
if wezterm.config_builder then
    config = wezterm.config_builder()
end

wezterm.on('update-right-status', function(window, pane)
    window:set_right_status(window:active_workspace())
end)

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
    -- copy/paste
    {
        key = 'c',
	mods = "CMD",
	action = act.CopyTo 'Clipboard'
    },
    {
        key = 'v',
	mods = "CMD",
	action = act.PasteFrom 'Clipboard'
    },
    -- workspaces
    {
        key = 'd',
	mods = "CMD",
	action = act.SwitchToWorkspace { name = 'default' },
    },
    {
        key = 'o',
	mods = "CMD",
	action = act.SwitchToWorkspace { name = 'monitoring', spawn = { args = { 'top' },}, },
    },
    -- Prompt name for workspace
    {
        key = 'n',
	mods = "CMD",
	action = act.PromptInputLine {
	    description = wezterm.format {
	        { Attribute = { Intensity = 'Bold' } },
		{ Foreground = { AnsiColor = 'Fuchsia' } },
		{ Text = 'Enter name for workspace' },
	    },
	    action = wezterm.action_callback(function(window, pane, line)
		if line then
		    window:perform_action(act.SwitchToWorkspace { name = line, }, pane)
		end
	    end),
	},
    },
    {
        key = 'f',
	mods = "CMD",
	action = wezterm.action_callback(function(window, pane)
	    local home = wezterm.home_dir
	    local workspaces = {}

	    for _, v in ipairs(wezterm.glob home .. '/personal/projects/*/') do
		table.insert(workspaces, { label = v })
	    end

	    window:perform_action(
		act.InputSelector {
		    action = wezterm.action_callback(
			function(inner_window, inner_pane, id, label)
			    if not id and not label then
				wezterm.log_info 'cancelled'
			    else
				wezterm.log_info('id = ' .. id)
				wezterm.log_info('label = ' .. label)
			    end
			end
		    )
		}
	    )
	end)
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
