local M = {}

---@param cmd string
---@param opts? { width?: number, height?: number, on_exit?: function }
function M.floating_process(cmd, opts)
  opts = opts or {}
  local on_exit = opts.on_exit or function() end
  local width_pct = opts.width or 0.8
  local height_pct = opts.height or 0.8

  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * width_pct)
  local height = math.floor(vim.o.lines * height_pct)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded"
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.fn.jobstart(cmd, {
    on_exit = function()
      vim.api.nvim_win_close(win, true)
      on_exit()
    end,
    term = true
  })

  vim.cmd('startinsert')
end


---@param filepath string
---@return string value
---@return string|nil error
function M.get_file_first_line(filepath)
  if vim.fn.filereadable(filepath) == 0 then
    return "", "file not readable"
  end

  local line = vim.fn.readfile(filepath)[1]
  if not line or line == "" then
    return "", "file was empty"
  end

  return line, nil
end

function M.load_json(path)
  local f = assert(io.open(path, "r"), "Unable to open JSON file: " .. path)
  local content = f:read("*a")
  f:close()

  return vim.json.decode(content)
end


return M
