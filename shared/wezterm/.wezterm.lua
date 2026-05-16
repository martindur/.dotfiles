local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on("update-right-status", function(window, _pane)
  window:set_right_status(window:active_workspace())
end)

config.font_size = 16
config.line_height = 1
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.bold_brightens_ansi_colors = true
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
config.window_background_opacity = 0.88
config.enable_tab_bar = false
config.set_environment_variables = {
  PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:" .. os.getenv("PATH")
}

local super = "CMD"
if not wezterm.target_triple:find("darwin") then
  super = "ALT"
end

local function basename(path)
  return path:gsub("/$", ""):match("([^/]+)$")
end

local function project_context_action(project_name, project_path)
  return act.SwitchToWorkspace({
    name = project_name,
    spawn = {
      label = project_name,
      cwd = project_path,
    },
  })
end

config.keys = {
  {
    key = 'w',
    mods = super,
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
        win:perform_action(act.SpawnTab 'CurrentPaneDomain', pane)
      elseif #tabs == 2 then
        local switch_to_tab = tabs[1].is_active and tabs[2] or tabs[2].is_active and tabs[1]
        win:perform_action(act.ActivateTab(switch_to_tab.index), pane)
      else
        print("This keybinding is not supported outside the first two tabs")
      end
    end)
  },
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
  {
    key = ".",
    mods = super,
    action = act.SwitchToWorkspace({
      name = "dotfiles",
      spawn = {
        label = "dotfiles",
        cwd = wezterm.home_dir .. "/.dotfiles",
      },
    }),
  },
  {
    key = "d",
    mods = super,
    action = project_context_action("discovery", wezterm.home_dir .. "/projects/discovery"),
  },
  {
    key = "b",
    mods = super,
    action = project_context_action("brisk", wezterm.home_dir .. "/projects/brisk"),
  },
  {
    key = "f",
    mods = super,
    action = wezterm.action_callback(function(window, pane)
      local workspaces = {}

      for _, path in ipairs(wezterm.glob(wezterm.home_dir .. "/projects/*/")) do
        local name = basename(path)
        table.insert(workspaces, { id = path, label = name })
      end

      window:perform_action(
        act.InputSelector({
          title = "Choose Project",
          choices = workspaces,
          fuzzy = true,
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if id and label then
              inner_window:perform_action(
                act.SwitchToWorkspace({
                  name = label,
                  spawn = {
                    label = label,
                    cwd = id,
                  },
                }),
                inner_pane
              )
            end
          end),
        }),
        pane
      )
    end),
  },
  {
    key = "p",
    mods = super,
    action = wezterm.action_callback(function(window, pane)
      local workspaces = {}

      for _, name in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, { id = name, label = name })
      end

      window:perform_action(
        act.InputSelector({
          title = "Choose Workspace",
          choices = workspaces,
          fuzzy = true,
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if id and label then
              inner_window:perform_action(act.SwitchToWorkspace({ name = label }), inner_pane)
            end
          end),
        }),
        pane
      )
    end),
  },
}

config.launch_menu = {
  {
    args = { "top" },
  },
}

table.insert(config.launch_menu, {
  label = "Bash",
  args = { "bash", "-l" },
})

return config
