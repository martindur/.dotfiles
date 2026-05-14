local M = {}

local ns = vim.api.nvim_create_namespace("repo_notes")
local state = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Repo notes" })
end

local function dirname(path)
  return vim.fn.fnamemodify(path, ":h")
end

local function normalize(path)
  return vim.fs.normalize(path)
end

local function relpath(root, path)
  root = normalize(root)
  path = normalize(path)
  local prefix = root .. "/"
  if path == root then
    return "."
  end
  if path:sub(1, #prefix) == prefix then
    return path:sub(#prefix + 1)
  end
  return path
end

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local contents = file:read("*a")
  file:close()
  return contents
end

local function write_file(path, contents)
  local ok = vim.fn.mkdir(dirname(path), "p")
  if ok == 0 then
    return false, "could not create " .. dirname(path)
  end

  local file, err = io.open(path, "w")
  if not file then
    return false, err
  end
  file:write(contents)
  file:close()
  return true
end

local function repo_for_path(path)
  local dir = vim.fn.isdirectory(path) == 1 and path or dirname(path)
  local result = vim.fn.systemlist({
    "git",
    "-C",
    dir,
    "rev-parse",
    "--show-toplevel",
    "--path-format=absolute",
    "--git-common-dir",
  })

  if vim.v.shell_error ~= 0 or #result < 2 then
    return nil
  end

  return {
    root = normalize(result[1]),
    git_dir = normalize(result[2]),
    store = normalize(result[2] .. "/info/repo-notes.json"),
  }
end

local function empty_store()
  return { version = 1, items = {} }
end

local function load_store(repo)
  local contents = read_file(repo.store)
  if not contents or contents == "" then
    return empty_store()
  end

  local ok, data = pcall(vim.json.decode, contents)
  if not ok or type(data) ~= "table" or type(data.items) ~= "table" then
    notify("Could not read " .. repo.store, vim.log.levels.ERROR)
    return empty_store()
  end

  data.version = data.version or 1
  return data
end

local function save_store(repo, data)
  table.sort(data.items, function(a, b)
    if a.path == b.path then
      return a.line < b.line
    end
    return a.path < b.path
  end)

  local encoded = vim.json.encode(data)
  local ok, err = write_file(repo.store, encoded .. "\n")
  if not ok then
    notify("Could not save notes: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end
  return true
end

local function get_state(repo)
  local key = repo.root
  if not state[key] then
    state[key] = {
      repo = repo,
      data = load_store(repo),
    }
  end
  return state[key]
end

local function current_repo()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    notify("Current buffer has no file", vim.log.levels.WARN)
    return nil
  end

  local repo = repo_for_path(name)
  if not repo then
    notify("Current file is not in a git repo", vim.log.levels.WARN)
    return nil
  end

  return repo
end

local function current_path(repo)
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return nil
  end
  return relpath(repo.root, name)
end

local function line_text(bufnr, lnum)
  local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum - 1, lnum, false)
  return ok and lines[1] or nil
end

local function normalize_note_text(text)
  return text:gsub("\r\n", "\n"):gsub("\\n", "\n")
end

local function wrap_line(line, width)
  if #line <= width then
    return { line }
  end

  local wrapped = {}
  local current = ""
  for word in line:gmatch("%S+") do
    if current == "" then
      current = word
    elseif #current + #word + 1 <= width then
      current = current .. " " .. word
    else
      wrapped[#wrapped + 1] = current
      current = word
    end
  end

  if current ~= "" then
    wrapped[#wrapped + 1] = current
  end

  return #wrapped > 0 and wrapped or { line }
end

local function format_note(diagnostic)
  local width = math.max(40, math.min(100, vim.o.columns - 18))
  local lines = {}

  for line in (diagnostic.message .. "\n"):gmatch("(.-)\n") do
    if line == "" then
      lines[#lines + 1] = " "
    else
      vim.list_extend(lines, wrap_line(line, width))
    end
  end

  return table.concat(lines, "\n")
end

local function find_anchor(bufnr, note)
  if not note.anchor or note.anchor == "" then
    return note.line
  end

  if line_text(bufnr, note.line) == note.anchor then
    return note.line
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local start_line = math.max(1, note.line - 30)
  local end_line = math.min(line_count, note.line + 30)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  for index, text in ipairs(lines) do
    if text == note.anchor then
      return start_line + index - 1
    end
  end

  return note.line
end

function M.render_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    vim.diagnostic.reset(ns, bufnr)
    return
  end

  local repo = repo_for_path(name)
  if not repo then
    vim.diagnostic.reset(ns, bufnr)
    return
  end

  local repo_state = get_state(repo)
  local path = relpath(repo.root, name)
  local diagnostics = {}
  local changed = false

  for _, note in ipairs(repo_state.data.items) do
    if note.path == path then
      local lnum = find_anchor(bufnr, note)
      if lnum ~= note.line then
        note.line = lnum
        changed = true
      end

      diagnostics[#diagnostics + 1] = {
        lnum = math.max(0, lnum - 1),
        col = 0,
        severity = vim.diagnostic.severity.HINT,
        source = "note",
        message = note.text,
      }
    end
  end

  vim.diagnostic.set(ns, bufnr, diagnostics)

  if changed then
    save_store(repo, repo_state.data)
  end
end

function M.render_visible()
  local seen = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    if not seen[bufnr] then
      seen[bufnr] = true
      M.render_buffer(bufnr)
    end
  end
end

function M.reload()
  state = {}
  M.render_visible()
  notify("Reloaded repo notes")
end

local function add_text(text)
  local repo = current_repo()
  if not repo then
    return
  end

  local path = current_path(repo)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  if text == "" then
    return
  end
  text = normalize_note_text(text)

  local repo_state = get_state(repo)
  repo_state.data.items[#repo_state.data.items + 1] = {
    path = path,
    line = line,
    anchor = line_text(0, line) or "",
    text = text,
    created_at = os.date("%Y-%m-%dT%H:%M:%S%z"),
  }

  if save_store(repo, repo_state.data) then
    M.render_buffer(0)
  end
end

function M.add()
  add_text(vim.fn.input("Note: "))
end

function M.delete_at_cursor()
  local repo = current_repo()
  if not repo then
    return
  end

  local path = current_path(repo)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local repo_state = get_state(repo)
  local kept = {}
  local removed = 0

  for _, note in ipairs(repo_state.data.items) do
    if note.path == path and note.line == line then
      removed = removed + 1
    else
      kept[#kept + 1] = note
    end
  end

  if removed == 0 then
    notify("No note on this line", vim.log.levels.WARN)
    return
  end

  repo_state.data.items = kept
  if save_store(repo, repo_state.data) then
    M.render_buffer(0)
    notify("Removed " .. removed .. " note" .. (removed == 1 and "" or "s"))
  end
end

function M.list()
  local repo = current_repo()
  if not repo then
    return
  end

  local repo_state = get_state(repo)
  local qf = {}
  for _, note in ipairs(repo_state.data.items) do
    qf[#qf + 1] = {
      filename = repo.root .. "/" .. note.path,
      lnum = note.line,
      col = 1,
      text = note.text:gsub("\n", " / "),
      type = "I",
    }
  end

  if #qf == 0 then
    notify("No notes in this repo")
    return
  end

  vim.fn.setqflist({}, " ", {
    title = "Repo notes",
    items = qf,
  })
  vim.cmd("copen")
end

function M.setup()
  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
      format = format_note,
    },
    underline = false,
    signs = true,
  }, ns)

  vim.api.nvim_create_user_command("NoteAdd", function(opts)
    add_text(opts.args ~= "" and opts.args or vim.fn.input("Note: "))
  end, { nargs = "*" })
  vim.api.nvim_create_user_command("NoteDone", M.delete_at_cursor, {})
  vim.api.nvim_create_user_command("NoteList", M.list, {})
  vim.api.nvim_create_user_command("NoteReload", M.reload, {})

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = function(args)
      M.render_buffer(args.buf)
    end,
  })
end

return M
