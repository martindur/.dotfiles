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

local function detect_nu()
  local success, stdout = wezterm.run_child_process({ "/bin/sh", "-lc", "command -v nu || true" })
  if not success then
    return nil
  end

  local nu_path = stdout:gsub("%s+$", "")
  if nu_path == "" then
    return nil
  end

  return nu_path
end

local nu = detect_nu()
if nu then
  config.default_prog = { nu, "-l" }
end

local function basename(path)
  return path:gsub("/$", ""):match("([^/]+)$")
end

local function get_git_project_info(pane)
  local cwd = pane:get_current_working_dir()
  if not cwd then
    return nil
  end

  local cwd_path = cwd.file_path
  local success, stdout = wezterm.run_child_process({
    "git", "-C", cwd_path, "rev-parse", "--show-toplevel"
  })

  if not success then
    return nil
  end

  return {
    git_root = stdout:gsub("%s+$", ""),
  }
end

local function get_worktrees(git_root)
  local success, stdout = wezterm.run_child_process({
    "git", "-C", git_root, "worktree", "list", "--porcelain"
  })

  if not success then
    return {}
  end

  local worktrees = {}
  local current = {}

  for line in stdout:gmatch("[^\r\n]+") do
    if line:match("^worktree ") then
      if current.path then
        table.insert(worktrees, current)
      end
      current = { path = line:match("^worktree (.+)$") }
    elseif line:match("^branch ") then
      current.branch = line:match("^branch refs/heads/(.+)$")
    elseif line:match("^detached") then
      current.detached = true
    end
  end

  if current.path then
    table.insert(worktrees, current)
  end

  return worktrees
end

config.keys = {
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
    key = "d",
    mods = super .. "|CTRL",
    action = act.SwitchToWorkspace({ name = "default" }),
  },
  {
    key = "i",
    mods = super,
    action = act.SwitchWorkspaceRelative(1),
  },
  {
    key = "o",
    mods = super,
    action = act.SwitchWorkspaceRelative(-1),
  },
  {
    key = "d",
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
  {
    key = "g",
    mods = super,
    action = wezterm.action_callback(function(window, pane)
      local project_info = get_git_project_info(pane)
      if not project_info then
        window:toast_notification("wezterm", "Not in a git repository", nil, 3000)
        return
      end

      local worktrees = get_worktrees(project_info.git_root)
      if #worktrees == 0 then
        window:toast_notification("wezterm", "No worktrees found", nil, 3000)
        return
      end

      local choices = {}
      for _, wt in ipairs(worktrees) do
        local label = wt.branch or basename(wt.path)
        table.insert(choices, { id = wt.path, label = label })
      end

      window:perform_action(
        act.InputSelector({
          title = "Choose Worktree",
          choices = choices,
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
}

config.launch_menu = {
  {
    args = { "top" },
  },
}

if nu then
  table.insert(config.launch_menu, {
    label = "Nushell",
    args = { nu, "-l" },
  })
end

table.insert(config.launch_menu, {
  label = "Bash",
  args = { "bash", "-l" },
})

return config
