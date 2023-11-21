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

-- helpers

function split (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end

  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local dotfiles = {
  {
    label = 'dotfiles',
    id = wezterm.home_dir..'/'..'.dotfiles',
  },
  {
    label = 'helix',
    id = wezterm.home_dir..'/.dotfiles/helix/.config/helix',
  },
  {
    label = 'homebrew',
    id = wezterm.home_dir..'/.dotfiles/homebrew/.config',
  },
  {
    label = 'nvim',
    id = wezterm.home_dir..'/.dotfiles/nvim/.config/nvim',
  },
  {
    label = 'wezterm',
    id = wezterm.home_dir..'/.dotfiles/wezterm',
  },
  {
    label = 'fish',
    id = wezterm.home_dir..'/.dotfiles/fish/.config/fish',
  },
  {
    label = 'bin (scripts)',
    id = wezterm.home_dir..'/.dotfiles/bin/.config/bin',
  },
  {
    label = 'qtile',
    id = wezterm.home_dir..'/.dotfiles/qtile/.config/qtile',
  },
  {
    label = 'docs',
    id = wezterm.home_dir..'/.dotfiles/docs',
  },
}

-- Key mappings

config.keys = {
    {
        key = "g",
        mods = "CMD",
        action = act.ShowLauncher,
    },
    {
    key = "i",
    mods = "CMD",
    action = act.SpawnCommandInNewTab {
      label = 'quick access to second brain',
      cwd = '/home/dur/2brain',
      domain = 'CurrentPaneDomain',
      args = { 'nvim', '2brain.md' }
    }
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
	mods = "CMD|CTRL",
	action = act.SwitchToWorkspace { name = 'default' },
    },
    {
        key = 'o',
	mods = "CMD",
	action = act.SwitchToWorkspace { name = 'monitoring', spawn = { args = { 'top' },}, },
    },
    {
	-- workspace from 'dotfiles'
	key = 'd',
	mods = "CMD",
	action = wezterm.action_callback(function(window, pane)
	    window:perform_action(
		act.InputSelector {
		    action = wezterm.action_callback(
			function(inner_window, inner_pane, id, label)
			    if not id and not label then
				wezterm.log_info 'cancelled'
			    else
				wezterm.log_info('id = ' .. id)
				wezterm.log_info('label = ' .. label)
				inner_window:perform_action(act.SwitchToWorkspace { name = label, spawn = { label = label, cwd = id }, }, inner_pane)
			    end
			end
		    ),
		    title = 'Choose Workspace',
		    choices = dotfiles,
		    fuzzy = true,
		},
		pane
	    )
	end)
    },
    {
	-- workspace from 'projects'
        key = 'f',
	mods = "CMD",
	action = wezterm.action_callback(function(window, pane)
	    local home = wezterm.home_dir
	    local workspaces = {}

	    for _, v in ipairs(wezterm.glob (home .. '/projects/*/')) do
		table.insert(workspaces, { id = v, label = v })
	    end

	    window:perform_action(
		act.InputSelector {
		    action = wezterm.action_callback(
			function(inner_window, inner_pane, id, label)
			    if not id and not label then
				wezterm.log_info 'cancelled'
			    else
				local directories = split(id, '/')
				local workspace = table.concat(directories, '\n', #directories)
				wezterm.log_info('id = ' .. id)
				wezterm.log_info('label = ' .. label)
				inner_window:perform_action(
				  act.SwitchToWorkspace {
				    name = workspace,
				    spawn = {
				      label = workspace,
				      cwd = id,
				    },
				  },
				  inner_pane
				)
			    end
			end
		    ),
		    title = 'Choose Workspace',
		    choices = workspaces,
		    fuzzy = true,
		},
		pane
	    )
	end)
    },
    {
	-- workspace from 'current workspaces'
	key = 'p',
	mods = "CMD",
	action = wezterm.action_callback(function(window, pane)
	    local home = wezterm.home_dir
	    local workspaces = {}

	    for _, v in ipairs(wezterm.mux.get_workspace_names()) do
		table.insert(workspaces, { id = v, label = v })
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
				inner_window:perform_action(act.SwitchToWorkspace { name = label, }, inner_pane)
			    end
			end
		    ),
		    title = 'Choose Workspace',
		    choices = workspaces,
		    fuzzy = true,
		},
		pane
	    )
	end)
    },
    {
	-- close workspace(all panes in all tabs) from 'current workspaces'
	key = 'q',
	mods = "CMD",
	action = wezterm.action_callback(function(window, pane)
	    local panes = {}
	    mux_window = window:mux_window()
	    wezterm.log_info(mux_window)

	    for _, tab in ipairs(mux_window:tabs()) do
	       for _, pane in ipairs(tab:panes()) do
		  table.insert(panes, pane:pane_id())
	       end
	    end

	    wezterm.log_info(panes)

	    -- DISABLED. Seems to freeze the terminal
	    --for _, pane_id in ipairs(panes) do
		--os.execute("wezterm cli kill-pane --pane-id "..pane_id)
	    --end
	end)
    }
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
