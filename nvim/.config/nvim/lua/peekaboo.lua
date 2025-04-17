local util = require('util')

local M = {}

local default_query_path = vim.fn.stdpath("cache") .. "/fzf_last_query"
local last_query_type = vim.fn.stdpath("cache") .. "/fzf_last_query_type"

local get_query = function(query_path)
  query_path = query_path or default_query_path
  if vim.fn.filereadable(query_path) == 0 then
    vim.notify("No previous query found", vim.log.levels.WARN)
    return ""
  end

  return vim.fn.readfile(query_path)[1] or ""
end

---@param filepath string
---@param callback fun(line: string)
local on_exit = function(filepath, callback)
  return function()
    local line, error = util.get_file_first_line(filepath)
    if error then
      vim.notify(error, vim.log.levels.WARN)
      return
    end
    callback(line)
  end
end

function M.find_files(query)
  query = query or ""
  local file = vim.fn.tempname()
  local cmd = string.format("fd --type f | fzf --query='%s' --bind 'enter:execute-silent(echo {q} > %s)+accept' --ansi --preview 'bat --style=numbers --color=always {}' > %s", query, default_query_path, file)

  util.floating_process(cmd, on_exit(file, function(line)
    vim.fn.writefile({"find_files"}, last_query_type)
    vim.cmd('edit ' .. vim.fn.fnameescape(line))
  end))
end

function M.find_files_include_hidden(query)
  query = query or ""
  local file = vim.fn.tempname()
  local cmd = string.format("fd --type f --hidden --exclude .git | fzf --query='%s' --bind 'enter:execute-silent(echo {q} > %s)+accept' --ansi --preview 'bat --style=numbers --color=always {}' > %s", query, default_query_path, file)
  util.floating_process(cmd, on_exit(file, function(line)
    vim.fn.writefile({"find_files_hidden"}, last_query_type)
    vim.cmd('edit ' .. vim.fn.fnameescape(line))
  end))
end

function M.live_grep(query)
  query = query or ""
  local file = vim.fn.tempname()
  local cmd = string.format([[
    fzf --ansi --phony \
    --prompt 'LiveGrep> ' \
    --query="%s" \
    --bind 'start:reload:rg --no-heading --line-number --color=always %s || true' \
    --bind 'change:reload:rg --no-heading --line-number --color=always {q} || true' \
    --bind 'enter:execute-silent(echo {q} > %s)+accept' \
    --delimiter : \
    --nth 3.. \
    --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
    > %s]],
    query,
    query,
    default_query_path,
    file
  )

  util.floating_process(cmd, on_exit(file, function(line)
    local filepath, linenum = line:match("^([^:]+):(%d+):")
    if filepath and linenum then
      vim.fn.writefile({"live_grep"}, last_query_type)
      vim.cmd(string.format("edit +%s %s", linenum, vim.fn.fnameescape(filepath)))
    end
  end))
end

function M.find_buffers(query)
  query = query or ""
  local input_path = vim.fn.tempname()
  local file = vim.fn.tempname()

  local lines = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.fn.buflisted(bufnr) == 1 then
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name ~= "" then
        local relname = vim.fn.fnamemodify(name, ":~:.")
        table.insert(lines, string.format("%d: %s", bufnr, relname))
      end
    end
  end

  vim.fn.writefile(lines, input_path)

  local cmd = string.format("cat %s | fzf --query='%s' --bind 'enter:execute-silent(echo {q} > %s)+accept' --ansi --preview 'bat --style=numbers --color=always {2}' > %s", input_path, query, default_query_path, file)

  util.floating_process(cmd, on_exit(file, function(line)
    local bufnr = tonumber(line:match("^(%d+):"))
    if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.writefile({"find_buffers"}, last_query_type)
      vim.cmd("buffer " .. bufnr)
    end
  end))
end

function M.last_query()
  local query = get_query()

  if vim.fn.filereadable(last_query_type) == 0 then return end

  local query_type = vim.fn.readfile(last_query_type)[1]
  if not query_type or query_type == "" then return end

  if query_type == "live_grep" then
    M.live_grep(query)
  elseif query_type == "find_files" then
    M.find_files(query)
  elseif query_type == "find_files_hidden" then
    M.find_files_include_hidden(query)
  elseif query_type == "find_buffers" then
    M.find_buffers(query)
  end
end


return M
