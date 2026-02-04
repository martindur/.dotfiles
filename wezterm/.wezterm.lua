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
config.window_background_opacity = 0.88
config.enable_tab_bar = false

-- Set environment variables including PATH
config.set_environment_variables = {
  PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:" .. os.getenv("PATH")
}

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

-- Get git project info for current pane
local function get_git_project_info(pane)
  local cwd = pane:get_current_working_dir()
  if not cwd then
    return nil
  end

  local cwd_path = cwd.file_path

  -- Get git root directory
  local success, stdout, stderr = wezterm.run_child_process({
    "git", "-C", cwd_path, "rev-parse", "--show-toplevel"
  })

  if not success then
    return nil
  end

  local git_root = stdout:gsub("%s+$", "")

  -- Extract project name from git root
  local project_name = git_root:match("([^/]+)$")

  return {
    git_root = git_root,
    project_name = project_name,
    cwd = cwd_path
  }
end

-- Parse git worktree list and return structured data
local function get_worktrees(git_root)
  local success, stdout, stderr = wezterm.run_child_process({
    "git", "-C", git_root, "worktree", "list", "--porcelain"
  })

  if not success then
    return {}
  end

  local worktrees = {}
  local current_worktree = {}

  for line in stdout:gmatch("[^\r\n]+") do
    if line:match("^worktree ") then
      if current_worktree.path then
        table.insert(worktrees, current_worktree)
      end
      current_worktree = {
        path = line:match("^worktree (.+)$")
      }
    elseif line:match("^branch ") then
      current_worktree.branch = line:match("^branch refs/heads/(.+)$")
    elseif line:match("^HEAD ") then
      current_worktree.head = line:match("^HEAD (.+)$")
    elseif line:match("^detached") then
      current_worktree.detached = true
    end
  end

  -- Add the last worktree
  if current_worktree.path then
    table.insert(worktrees, current_worktree)
  end

  return worktrees
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
    label = "aerospace",
    id = wezterm.home_dir .. "/.dotfiles/aerospace/.config/aerospace",
  },
  {
    label = "sketchybar",
    id = wezterm.home_dir .. "/.dotfiles/sketchybar/.config/sketchybar",
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
    -- Manage worktrees with yazi
    key = "y",
    mods = super,
    action = act.SwitchToWorkspace({
      name = "worktrees",
      spawn = {
        label = "worktrees",
        cwd = wezterm.home_dir .. "/worktrees",
        args = { "yazi" }
      },
    }),
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
  -- Git worktree management
  {
    -- Browse existing worktrees
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
        local label = wt.path
        if wt.branch then
          label = wt.path .. " (" .. wt.branch .. ")"
        elseif wt.detached then
          label = wt.path .. " (detached HEAD)"
        end

        table.insert(choices, {
          id = wt.path,
          label = label
        })
      end

      window:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if not id and not label then
              wezterm.log_info("cancelled")
            else
              local workspace_name = id:match("([^/]+)$")
              inner_window:perform_action(
                act.SwitchToWorkspace({
                  name = workspace_name,
                  spawn = {
                    label = workspace_name,
                    cwd = id,
                  },
                }),
                inner_pane
              )
            end
          end),
          title = "Choose Worktree",
          choices = choices,
          fuzzy = true,
        }),
        pane
      )
    end),
  },
  {
    -- Create new worktree
    key = "N",
    mods = super .. "|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      wezterm.log_info("Create worktree keybinding triggered")
      local project_info = get_git_project_info(pane)

      if not project_info then
        wezterm.log_error("Not in a git repository")
        window:toast_notification("wezterm", "Not in a git repository", nil, 3000)
        return
      end
      
      wezterm.log_info("Project: " .. project_info.project_name)
      wezterm.log_info("Git root: " .. project_info.git_root)

      window:perform_action(
        act.PromptInputLine({
          description = "Enter name for new worktree/branch:",
          action = wezterm.action_callback(function(inner_window, inner_pane, line)
            wezterm.log_info("User input: " .. tostring(line))
            if not line or line == "" then
              wezterm.log_info("Empty input, returning")
              return
            end

            local home = wezterm.home_dir
            local worktree_base = home .. "/worktrees/" .. project_info.project_name
            local worktree_path = worktree_base .. "/" .. line
            
            wezterm.log_info("Worktree path: " .. worktree_path)
            
            -- Create the base directory if it doesn't exist
            local mkdir_success, mkdir_stdout, mkdir_stderr = wezterm.run_child_process({"mkdir", "-p", worktree_base})
            wezterm.log_info("mkdir result: " .. tostring(mkdir_success))

            -- Determine the main branch (try origin/main, fallback to origin/master)
            local main_branch = "origin/main"
            local check_main, check_stdout, check_stderr = wezterm.run_child_process({
              "git", "-C", project_info.git_root, "rev-parse", "--verify", "origin/main"
            })
            
            wezterm.log_info("Check origin/main: " .. tostring(check_main))

            if not check_main then
              main_branch = "origin/master"
              wezterm.log_info("Using origin/master instead")
            end

            wezterm.log_info("Creating worktree with branch: " .. main_branch)
            
            -- First, try to create the worktree with a new branch
            local success, stdout, stderr = wezterm.run_child_process({
              "git", "-C", project_info.git_root, "worktree", "add", "-b", line, worktree_path, main_branch
            })

            -- If branch already exists, check if it's orphaned and handle it
            if not success and stderr:match("already exists") then
              wezterm.log_info("Branch already exists, checking if it's orphaned...")
              
              -- Check if the branch is associated with any worktree
              local wt_list = get_worktrees(project_info.git_root)
              local branch_in_use = false
              for _, wt in ipairs(wt_list) do
                if wt.branch == line then
                  branch_in_use = true
                  break
                end
              end
              
              if not branch_in_use then
                wezterm.log_info("Branch is orphaned, deleting and recreating...")
                
                -- Delete the orphaned branch
                wezterm.run_child_process({
                  "git", "-C", project_info.git_root, "branch", "-D", line
                })
                
                -- Try creating the worktree again
                success, stdout, stderr = wezterm.run_child_process({
                  "git", "-C", project_info.git_root, "worktree", "add", "-b", line, worktree_path, main_branch
                })
              else
                wezterm.log_error("Branch is in use by another worktree")
                inner_window:toast_notification("wezterm", "Branch already in use by another worktree", nil, 5000)
                return
              end
            end

            wezterm.log_info("Git worktree add result: " .. tostring(success))
            if stdout and stdout ~= "" then
              wezterm.log_info("stdout: " .. stdout)
            end
            if stderr and stderr ~= "" then
              wezterm.log_error("stderr: " .. stderr)
            end

            if not success then
              inner_window:toast_notification("wezterm", "Failed to create worktree: " .. stderr, nil, 5000)
              return
            end

            inner_window:toast_notification("wezterm", "Worktree created: " .. line, nil, 3000)

            -- Switch to new workspace at the worktree location
            inner_window:perform_action(
              act.SwitchToWorkspace({
                name = line,
                spawn = {
                  label = line,
                  cwd = worktree_path,
                },
              }),
              inner_pane
            )
          end),
        }),
        pane
      )
    end),
  },
  {
    -- Delete worktree
    key = "D",
    mods = super .. "|SHIFT",
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
      
      -- Filter out the main worktree (usually the project root)
      local choices = {}
      for _, wt in ipairs(worktrees) do
        -- Skip the main worktree
        if wt.path ~= project_info.git_root then
          local label = wt.path
          if wt.branch then
            label = wt.path .. " (" .. wt.branch .. ")"
          elseif wt.detached then
            label = wt.path .. " (detached HEAD)"
          end
          
          table.insert(choices, {
            id = wt.path,
            label = label
          })
        end
      end
      
      if #choices == 0 then
        window:toast_notification("wezterm", "No worktrees to delete", nil, 3000)
        return
      end
      
      window:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if not id and not label then
              wezterm.log_info("cancelled")
            else
              -- Remove the worktree (--force to handle any state)
              local success, stdout, stderr = wezterm.run_child_process({
                "git", "-C", project_info.git_root, "worktree", "remove", "--force", id
              })
              
              if success then
                inner_window:toast_notification("wezterm", "Worktree deleted: " .. id, nil, 3000)
              else
                inner_window:toast_notification("wezterm", "Failed to delete worktree: " .. stderr, nil, 5000)
              end
            end
          end),
          title = "Delete Worktree",
          choices = choices,
          fuzzy = true,
        }),
        pane
      )
    end),
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
