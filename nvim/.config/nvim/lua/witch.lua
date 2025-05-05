local M = {}

local ns_id = vim.api.nvim_create_namespace("witch")
local win, buf = nil, nil
local current_prefix = ""
local sequence_buffer = ""

local function close_popup()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  win, buf, current_prefix, sequence_buffer = nil, nil, "", ""
end

local function show_hints(prefix)
  local matches = {}
  for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
    if map.lhs:sub(1, #prefix) == prefix and #map.lhs > #prefix then
      local remainder = map.lhs:sub(#prefix + 1)
      local desc = map.desc or map.rhs or ""
      table.insert(matches, string.format(" %s \t→ %s", remainder, desc))
    end
  end

  if #matches == 0 then
    close_popup()
    return
  end

  table.sort(matches)

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, matches)

  local width = 50
  local height = math.min(#matches, 10)
  local row = vim.o.lines - height - 2
  local col = vim.o.columns - width - 2

  if not win or not vim.api.nvim_win_is_valid(win) then
    win = vim.api.nvim_open_win(buf, false, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    })
  end
end

local function get_prefixes()
  local seen = {}
  for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
    local lhs = map.lhs
    local prefix = ""
    for _, c in ipairs(vim.fn.split(lhs, "\\zs")) do
      prefix = prefix .. c
      seen[prefix] = true
    end
  end
  return seen
end

local function install_prefix_traps()
  for prefix, _ in pairs(get_prefixes()) do
    if vim.fn.maparg(prefix, "n") == "" then
      vim.keymap.set("n", prefix, function()
        current_prefix = prefix
        sequence_buffer = prefix
        show_hints(sequence_buffer)
        -- Don't feed key here to avoid double execution
      end, { noremap = true, nowait = true, silent = true })
    end
  end
end

function M.setup()
  install_prefix_traps()

  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = function()
      if vim.fn.mode() ~= "n" then close_popup() end
    end,
  })

  vim.on_key(function(char)
    if vim.fn.mode() ~= "n" then return end

    local key = vim.fn.keytrans(char)
    if key == "<Esc>" or key == "<C-c>" then
      close_popup()
      return
    end

    if sequence_buffer ~= "" then
      sequence_buffer = sequence_buffer .. key
      show_hints(sequence_buffer)

      local match = vim.fn.maparg(sequence_buffer, "n", false, true)
      if match and match.lhs == sequence_buffer then
        close_popup()
        vim.schedule(function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(match.lhs, true, false, true), "m", false)
        end)
      end
    end
  end, ns_id)
end

return M
