local M = {}

function M.floating_process(cmd, on_exit)
  local buf = vim.api.nvim_create_buf(false, true)
  on_exit = on_exit or function() end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
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
