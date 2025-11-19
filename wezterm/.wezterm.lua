-- wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- config table
local config = {}

-- config_builder available in newer versions of wezterm
if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(window:active_workspace())
end)

-- Config

config.font_size = 16
config.line_height = 1
config.font = wezterm.font("Fira Code")
config.bold_brightens_ansi_colors = true
config.font_rules = {
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font({ family = "Maple Mono", weight = "Bold", style = "Italic" })
  },
  {
    intensity = "Half",
    italic = true,
    font = wezterm.font({ family = "Maple Mono", weight = "DemiBold", style = "Italic" })
  },
  {
    intensity = "Normal",
    italic = true,
    font = wezterm.font({ family = "Maple Mono", style = "Italic" })
  }
}
-- config.color_scheme = "Tokyo Night Moon"
config.color_scheme = "tokyonight_night"
config.colors = {
  cursor_bg = '#7aa2f7',
  cursor_border = '#7aa2f7'
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0
}
config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.85
config.enable_tab_bar = false

local function calculate_padding(window, max_content_width)
  local current_padding = window:effective_config().window_padding
  local window_dims = window:get_dimensions()

  -- Toggle padding off, if it's on
  if current_padding.left ~= "0px" and current_padding.right ~= "0px" then
    return 0, 0
  end

  local total_padding = window_dims.pixel_width - max_content_width
  if total_padding < 0 then
    return 0, 0
  end

  local left_padding = math.floor(total_padding / 2)
  local right_padding = total_padding - left_padding
  return left_padding, right_padding
end


local super = "CMD"

-- helpers

function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end

  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local dotfiles = {
  {
    label = "dotfiles",
    id = wezterm.home_dir .. "/" .. ".dotfiles",
  },
  {
    label = "homebrew",
    id = wezterm.home_dir .. "/.dotfiles/homebrew/.config",
  },
  {
    label = "nvim",
    id = wezterm.home_dir .. "/.dotfiles/nvim/.config/nvim",
  },
  {
    label = "vim",
    id = wezterm.home_dir .. "/.dotfiles/vim",
  },
  {
    label = "helix",
    id = wezterm.home_dir .. "/.dotfiles/helix/.config/helix",
  },
  {
    label = "wezterm",
    id = wezterm.home_dir .. "/.dotfiles/wezterm",
  },
  {
    label = "zsh",
    id = wezterm.home_dir .. "/.dotfiles/zsh",
  },
  {
    label = "bin (scripts)",
    id = wezterm.home_dir .. "/.dotfiles/bin/.config/bin",
  },
  {
    label = "docs",
    id = wezterm.home_dir .. "/.dotfiles/docs",
  },
}

-- Key mappings

config.keys = {
  --    {
  --       key = "g",
  --      mods = "CMD",
  --       action = act.ShowLauncher,
  --    },
  -- {
  -- 	key = "i",
  -- 	mods = "CMD",
  -- 	action = act.SpawnCommandInNewTab({
  -- 		label = "quick access to second brain",
  -- 		cwd = "/home/dur/2brain",
  -- 		domain = "CurrentPaneDomain",
  -- 		args = { "steam-run", "nvim", "2brain.md" },
  -- 	}),
  -- },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = "z",
    mods = super,
    action = act.TogglePaneZoomState,
  },
  {
    key = "t",
    mods = super,
    action = wezterm.action_callback(function(win, pane)
      local tabs = win:mux_window():tabs_with_info()
      if #tabs < 2 then
        win:perform_action(
          act.SpawnTab 'CurrentPaneDomain',
          pane
        )
      elseif #tabs == 2 then
        local switch_to_tab = tabs[1].is_active and tabs[2] or tabs[2].is_active and tabs[1]
        win:perform_action(
          act.ActivateTab(switch_to_tab.index),
          pane
        )
      else
        print("This keybinding is not supported outside the first two tabs")
      end
    end)
  },
  {
    key = "g",
    mods = super,
    action = act.SpawnCommandInNewTab({
      label = "open lazygit in a new tab",
      domain = "CurrentPaneDomain",
      args = { "lazygit" },
    }),
  },
  -- pane create/remove
  {
    key = "m",
    mods = super,
    action = act.SplitPane({
      direction = "Right",
      size = { Percent = 25 },
    }),
  },
  {
    key = "u",
    mods = super,
    action = act.SplitPane({
      direction = "Down",
      size = { Percent = 30 },
    }),
  },
  {
    key = "q",
    mods = super,
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },

  -- pane resizing
  {
    key = "LeftArrow",
    mods = super,
    action = act.AdjustPaneSize({ "Left", 5 }),
  },
  {
    key = "RightArrow",
    mods = super,
    action = act.AdjustPaneSize({ "Right", 5 }),
  },
  {
    key = "UpArrow",
    mods = super,
    action = act.AdjustPaneSize({ "Up", 5 }),
  },
  {
    key = "DownArrow",
    mods = super,
    action = act.AdjustPaneSize({ "Down", 5 }),
  },
  -- pane navigation
  {
    key = "h",
    mods = super,
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = super,
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = super,
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = super,
    action = act.ActivatePaneDirection("Right"),
  },
  -- copy/paste
  {
    key = "c",
    mods = super,
    action = act.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = super,
    action = act.PasteFrom("Clipboard"),
  },
  -- workspaces
  {
    key = "d",
    mods = super .. "|CTRL",
    action = act.SwitchToWorkspace({ name = "default" }),
  },
  -- notes workspace
  {
    key = "i",
    mods = super,
    action = act.SwitchToWorkspace({
      name = "notes",
      spawn = { cwd = "/home/dur/documents/notes", label = "notes", args = { "nvim", "." } },
    }),
  },
  {
    key = "y",
    mods = super,
    action = act.SpawnCommandInNewTab({
      label = "scratchpad for the day!",
      cwd = "/home/dur/documents/notes",
      domain = "CurrentPaneDomain",
      args = { "zsh", "-c", "nvim scratchpads/$(date +'%Y-%m-%d').md" },
    }),
  },
  {
    key = "o",
    mods = super,
    action = act.SwitchWorkspaceRelative(-1),
  },
  {
    -- workspace from 'dotfiles'
    key = "d",
    mods = super,
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if not id and not label then
              wezterm.log_info("cancelled")
            else
              wezterm.log_info("id = " .. id)
              wezterm.log_info("label = " .. label)
              inner_window:perform_action(
                act.SwitchToWorkspace({ name = label, spawn = { label = label, cwd = id } }),
                inner_pane
              )
            end
          end),
          title = "Choose Workspace",
          choices = dotfiles,
          fuzzy = true,
        }),
        pane
      )
    end),
  },
  {
    -- workspace from 'projects'
    key = "f",
    mods = super,
    action = wezterm.action_callback(function(window, pane)
      local home = wezterm.home_dir
      local workspaces = {}

      for _, v in ipairs(wezterm.glob(home .. "/projects/*/")) do
        table.insert(workspaces, { id = v, label = v })
      end

      window:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if not id and not label then
              wezterm.log_info("cancelled")
            else
              local directories = split(id, "/")
              local workspace = table.concat(directories, "\n", #directories)
              wezterm.log_info("id = " .. id)
              wezterm.log_info("label = " .. label)
              inner_window:perform_action(
                act.SwitchToWorkspace({
                  name = workspace,
                  spawn = {
                    label = workspace,
                    cwd = id,
                  },
                }),
                inner_pane
              )
            end
          end),
          title = "Choose Workspace",
          choices = workspaces,
          fuzzy = true,
        }),
        pane
      )
    end),
  },
  {
    -- workspace from 'current workspaces'
    key = "p",
    mods = super,
    action = wezterm.action_callback(function(window, pane)
      local home = wezterm.home_dir
      local workspaces = {}

      for _, v in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, { id = v, label = v })
      end

      window:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if not id and not label then
              wezterm.log_info("cancelled")
            else
              wezterm.log_info("id = " .. id)
              wezterm.log_info("label = " .. label)
              inner_window:perform_action(act.SwitchToWorkspace({ name = label }), inner_pane)
            end
          end),
          title = "Choose Workspace",
          choices = workspaces,
          fuzzy = true,
        }),
        pane
      )
    end),
  },
  --{
  -- close workspace(all panes in all tabs) from 'current workspaces'
  --key = 'q',
  --mods = "CMD",
  --action = wezterm.action_callback(function(window, pane)
  --    local panes = {}
  --    mux_window = window:mux_window()
  --    wezterm.log_info(mux_window)
  --
  --    for _, tab in ipairs(mux_window:tabs()) do
  --       for _, pane in ipairs(tab:panes()) do
  --		  table.insert(panes, pane:pane_id())
  --       end
  --    end

  --    wezterm.log_info(panes)

  -- DISABLED. Seems to freeze the terminal
  --for _, pane_id in ipairs(panes) do
  --os.execute("wezterm cli kill-pane --pane-id "..pane_id)
  --end
  --end)
  --}
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
