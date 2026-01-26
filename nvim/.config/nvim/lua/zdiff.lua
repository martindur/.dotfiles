local M = {}

-- State
---@class ZdiffFile
---@field path string relative file path
---@field status string git status (M, A, D, etc.)
---@field insertions number lines added
---@field deletions number lines deleted
---@field expanded boolean whether the file is expanded
---@field hunks ZdiffHunk[] parsed diff hunks

---@class ZdiffHunk
---@field old_start number starting line in old file
---@field old_count number number of lines in old file
---@field new_start number starting line in new file
---@field new_count number number of lines in new file
---@field lines ZdiffLine[] individual diff lines

---@class ZdiffLine
---@field type "context"|"add"|"del"|"header" line type
---@field text string the line content (without +/- prefix)
---@field new_lnum number|nil line number in new file (for context/add lines)
---@field old_lnum number|nil line number in old file (for context/del lines)

---@class ZdiffState
---@field files ZdiffFile[]
---@field buf number|nil buffer handle
---@field win number|nil window handle
---@field mode "uncommitted"|"main" diff mode
---@field line_map table<number, {file_idx: number, hunk_idx: number|nil, line_idx: number|nil, lnum: number|nil}>

---@type ZdiffState
local state = {
  files = {},
  buf = nil,
  win = nil,
  mode = "uncommitted",
  line_map = {},
}

-- Forward declarations
local goto_source

-- Configuration
M.config = {
  context_lines = 3,
  keymaps = {
    toggle = "<CR>",
    goto_file = "<CR>",
    close = "q",
    refresh = "R",
    toggle_mode = "m",
  },
  icons = {
    collapsed = "",
    expanded = "",
    added = "+",
    deleted = "-",
    modified = "~",
  },
}

---Get the git root directory
---@return string|nil
local function get_git_root()
  local result = vim.fn.systemlist("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result[1]
end

---Get the base ref for diffing
---@param mode "uncommitted"|"main"
---@return string
local function get_base_ref(mode)
  if mode == "main" then
    -- Try to find the default branch
    local result = vim.fn.systemlist("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null")
    if vim.v.shell_error == 0 and result[1] then
      return result[1]:gsub("refs/remotes/origin/", "")
    end
    -- Fallback to common names
    for _, branch in ipairs({ "main", "master" }) do
      local check = vim.fn.system("git rev-parse --verify " .. branch .. " 2>/dev/null")
      if vim.v.shell_error == 0 then
        return branch
      end
    end
    return "main"
  end
  return "HEAD"
end

---Parse the diff stat output to get file statistics
---@param mode "uncommitted"|"main"
---@return table<string, {insertions: number, deletions: number, status: string}>
local function get_diff_stats(mode)
  local base = get_base_ref(mode)
  local cmd
  if mode == "uncommitted" then
    cmd = "git diff --numstat HEAD"
  else
    cmd = "git diff --numstat " .. base .. "...HEAD"
  end

  local stats = {}
  local result = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return stats
  end

  for _, line in ipairs(result) do
    local ins, del, path = line:match("^(%d+)%s+(%d+)%s+(.+)$")
    if path then
      stats[path] = {
        insertions = tonumber(ins) or 0,
        deletions = tonumber(del) or 0,
        status = "M",
      }
    end
  end

  -- Get status for each file
  local status_cmd
  if mode == "uncommitted" then
    status_cmd = "git diff --name-status HEAD"
  else
    status_cmd = "git diff --name-status " .. base .. "...HEAD"
  end

  local status_result = vim.fn.systemlist(status_cmd)
  for _, line in ipairs(status_result) do
    local status, path = line:match("^(%a)%s+(.+)$")
    if path and stats[path] then
      stats[path].status = status
    elseif path then
      stats[path] = { insertions = 0, deletions = 0, status = status }
    end
  end

  return stats
end

---Parse a unified diff hunk header
---@param header string the @@ line
---@return number old_start, number old_count, number new_start, number new_count
local function parse_hunk_header(header)
  local old_start, old_count, new_start, new_count =
      header:match("^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@")
  return tonumber(old_start) or 0,
      tonumber(old_count) or 1,
      tonumber(new_start) or 0,
      tonumber(new_count) or 1
end

---Parse diff output for a single file into hunks
---@param diff_lines string[]
---@return ZdiffHunk[]
local function parse_diff_hunks(diff_lines)
  local hunks = {}
  local current_hunk = nil
  local old_lnum, new_lnum = 0, 0

  for _, line in ipairs(diff_lines) do
    if line:match("^@@") then
      -- New hunk
      if current_hunk then
        table.insert(hunks, current_hunk)
      end
      local old_start, old_count, new_start, new_count = parse_hunk_header(line)
      old_lnum = old_start
      new_lnum = new_start
      current_hunk = {
        old_start = old_start,
        old_count = old_count,
        new_start = new_start,
        new_count = new_count,
        lines = {},
      }
    elseif current_hunk then
      local diff_line = {
        text = line:sub(2), -- Remove the +/- prefix
        type = "context",
        new_lnum = nil,
        old_lnum = nil,
      }

      if line:match("^%+") then
        diff_line.type = "add"
        diff_line.new_lnum = new_lnum
        new_lnum = new_lnum + 1
      elseif line:match("^%-") then
        diff_line.type = "del"
        diff_line.old_lnum = old_lnum
        old_lnum = old_lnum + 1
      elseif line:match("^ ") or line == "" then
        diff_line.type = "context"
        diff_line.new_lnum = new_lnum
        diff_line.old_lnum = old_lnum
        new_lnum = new_lnum + 1
        old_lnum = old_lnum + 1
      end

      table.insert(current_hunk.lines, diff_line)
    end
  end

  if current_hunk then
    table.insert(hunks, current_hunk)
  end

  return hunks
end

---Get diff hunks for a specific file
---@param filepath string
---@param mode "uncommitted"|"main"
---@return ZdiffHunk[]
local function get_file_diff(filepath, mode)
  local base = get_base_ref(mode)
  local cmd
  if mode == "uncommitted" then
    cmd = string.format("git diff HEAD -- %s", vim.fn.shellescape(filepath))
  else
    cmd = string.format("git diff %s...HEAD -- %s", base, vim.fn.shellescape(filepath))
  end

  local result = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return {}
  end

  return parse_diff_hunks(result)
end

---Load all changed files and their stats
---@param mode "uncommitted"|"main"
---@return ZdiffFile[]
local function load_files(mode)
  local stats = get_diff_stats(mode)
  local files = {}

  for path, info in pairs(stats) do
    table.insert(files, {
      path = path,
      status = info.status,
      insertions = info.insertions,
      deletions = info.deletions,
      expanded = false,
      hunks = {},
    })
  end

  -- Sort by path
  table.sort(files, function(a, b)
    return a.path < b.path
  end)

  return files
end

---Get the status icon for a file
---@param status string
---@return string
local function get_status_icon(status)
  if status == "A" then
    return M.config.icons.added
  elseif status == "D" then
    return M.config.icons.deleted
  else
    return M.config.icons.modified
  end
end

---Get highlight group for diff line type
---@param line_type "context"|"add"|"del"|"header"
---@return string
local function get_line_highlight(line_type)
  if line_type == "add" then
    return "DiffAdd"
  elseif line_type == "del" then
    return "DiffDelete"
  elseif line_type == "header" then
    return "Title"
  else
    return "Normal"
  end
end

---Render the zdiff buffer
local function render()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end

  vim.api.nvim_buf_set_option(state.buf, "modifiable", true)

  local lines = {}
  local highlights = {} -- {line_idx, hl_group, col_start, col_end}
  state.line_map = {}

  -- Header
  local mode_text = state.mode == "uncommitted" and "Uncommitted changes" or "Changes vs main"
  table.insert(lines, string.format(" zdiff: %s", mode_text))
  table.insert(lines, string.rep("─", 60))
  table.insert(highlights, { #lines - 1, "Title", 0, -1 })
  table.insert(highlights, { #lines, "Comment", 0, -1 })

  if #state.files == 0 then
    table.insert(lines, "")
    table.insert(lines, "  No changes found")
    table.insert(highlights, { #lines, "Comment", 0, -1 })
  else
    for file_idx, file in ipairs(state.files) do
      -- File header line
      local icon = file.expanded and M.config.icons.expanded or M.config.icons.collapsed
      local status_icon = get_status_icon(file.status)
      local add_stat = string.format("+%d", file.insertions)
      local del_stat = string.format("-%d", file.deletions)
      local file_line = string.format("%s %s %s  %s %s", icon, status_icon, file.path, add_stat, del_stat)
      table.insert(lines, file_line)

      -- Map this line to the file
      state.line_map[#lines] = { file_idx = file_idx }

      -- Calculate positions for highlighting
      local line_text = lines[#lines]
      local add_start = #line_text - #add_stat - #del_stat - 1
      local add_end = add_start + #add_stat
      local del_start = add_end + 1
      local del_end = del_start + #del_stat

      -- Highlight the file path part
      table.insert(highlights, { #lines, "Directory", 0, add_start })
      -- Highlight +N in green
      table.insert(highlights, { #lines, "DiffAdd", add_start, add_end })
      -- Highlight -M in red
      table.insert(highlights, { #lines, "DiffDelete", del_start, del_end })

      -- If expanded, show hunks
      if file.expanded then
        -- Load hunks if not already loaded
        if #file.hunks == 0 then
          file.hunks = get_file_diff(file.path, state.mode)
        end

        for hunk_idx, hunk in ipairs(file.hunks) do
          -- Hunk header
          local hunk_header = string.format(
            "    @@ -%d,%d +%d,%d @@",
            hunk.old_start,
            hunk.old_count,
            hunk.new_start,
            hunk.new_count
          )
          table.insert(lines, hunk_header)
          state.line_map[#lines] = { file_idx = file_idx, hunk_idx = hunk_idx }
          table.insert(highlights, { #lines, "Comment", 0, -1 })

          -- Diff lines
          for line_idx, diff_line in ipairs(hunk.lines) do
            local prefix = "    "
            if diff_line.type == "add" then
              prefix = "   +"
            elseif diff_line.type == "del" then
              prefix = "   -"
            else
              prefix = "    "
            end

            local display_line = prefix .. diff_line.text
            table.insert(lines, display_line)

            -- Map this line
            state.line_map[#lines] = {
              file_idx = file_idx,
              hunk_idx = hunk_idx,
              line_idx = line_idx,
              lnum = diff_line.new_lnum or diff_line.old_lnum,
            }

            table.insert(highlights, { #lines, get_line_highlight(diff_line.type), 0, -1 })
          end
        end
      end
    end
  end

  -- Set lines
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)

  -- Apply highlights
  local ns = vim.api.nvim_create_namespace("zdiff")
  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
  for _, hl in ipairs(highlights) do
    local line_idx, hl_group, col_start, col_end = hl[1], hl[2], hl[3], hl[4]
    vim.api.nvim_buf_add_highlight(state.buf, ns, hl_group, line_idx - 1, col_start, col_end)
  end

  vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
end

---Toggle expansion of file under cursor
local function toggle_file()
  local cursor_line = vim.api.nvim_win_get_cursor(state.win)[1]
  local mapping = state.line_map[cursor_line]

  if mapping and mapping.file_idx and not mapping.line_idx then
    -- On a file header or hunk header, toggle the file
    local file = state.files[mapping.file_idx]
    if file then
      file.expanded = not file.expanded
      render()
    end
  elseif mapping and mapping.file_idx and mapping.lnum then
    -- On a diff line, go to file
    goto_source()
  end
end

---Go to the source file at the correct line
goto_source = function()
  local cursor_line = vim.api.nvim_win_get_cursor(state.win)[1]
  local mapping = state.line_map[cursor_line]

  if not mapping or not mapping.file_idx then
    return
  end

  local file = state.files[mapping.file_idx]
  if not file then
    return
  end

  local git_root = get_git_root()
  local filepath = git_root and (git_root .. "/" .. file.path) or file.path

  -- Determine target line
  local target_line = 1
  if mapping.lnum then
    target_line = mapping.lnum
  elseif mapping.hunk_idx and file.hunks[mapping.hunk_idx] then
    target_line = file.hunks[mapping.hunk_idx].new_start
  end

  -- Open file in the zdiff window (replaces zdiff buffer, but buffer persists hidden)
  -- This adds to jumplist so C-o returns to zdiff
  vim.cmd("edit " .. vim.fn.fnameescape(filepath))
  vim.api.nvim_win_set_cursor(0, { target_line, 0 })
  vim.cmd("normal! zz") -- Center the line
end

---Refresh the diff view
local function refresh()
  state.files = load_files(state.mode)
  render()
end

---Toggle between uncommitted and main modes
local function toggle_mode()
  state.mode = state.mode == "uncommitted" and "main" or "uncommitted"
  -- Reset expansion and reload
  for _, file in ipairs(state.files) do
    file.expanded = false
    file.hunks = {}
  end
  refresh()
end

---Close the zdiff window and wipe the buffer
local function close()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state.buf = nil
  state.win = nil
end

---Create the zdiff buffer and window
---@param mode? "uncommitted"|"main"
function M.open(mode)
  -- Check if we're in a git repo
  if not get_git_root() then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  -- If zdiff buffer already exists, just switch to it
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    state.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(state.win, state.buf)
    return
  end

  state.mode = mode or "uncommitted"

  -- Create buffer
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(state.buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(state.buf, "bufhidden", "hide")
  vim.api.nvim_buf_set_option(state.buf, "swapfile", false)
  vim.api.nvim_buf_set_name(state.buf, "zdiff")
  vim.api.nvim_buf_set_option(state.buf, "filetype", "zdiff")

  -- Open in current window
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.win, state.buf)

  -- Window options
  vim.api.nvim_win_set_option(state.win, "number", false)
  vim.api.nvim_win_set_option(state.win, "relativenumber", false)
  vim.api.nvim_win_set_option(state.win, "signcolumn", "no")
  vim.api.nvim_win_set_option(state.win, "wrap", false)
  vim.api.nvim_win_set_option(state.win, "cursorline", true)

  -- Set up keymaps
  local opts = { buffer = state.buf, silent = true }
  vim.keymap.set("n", M.config.keymaps.toggle, toggle_file, opts)
  vim.keymap.set("n", M.config.keymaps.close, close, opts)
  vim.keymap.set("n", M.config.keymaps.refresh, refresh, opts)
  vim.keymap.set("n", M.config.keymaps.toggle_mode, toggle_mode, opts)

  -- Load and render
  refresh()
end

---Open zdiff comparing HEAD to main
function M.open_vs_main()
  M.open("main")
end

---Setup function
---@param opts? table
function M.setup(opts)
  if opts then
    M.config = vim.tbl_deep_extend("force", M.config, opts)
  end

  -- Create user commands
  vim.api.nvim_create_user_command("Zdiff", function()
    M.open("uncommitted")
  end, { desc = "Open zdiff for uncommitted changes" })

  vim.api.nvim_create_user_command("ZdiffMain", function()
    M.open("main")
  end, { desc = "Open zdiff comparing to main branch" })
end

return M
