local M = {}


M.has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end


M.find_cmd = function(cmd, prefixes, start_from, stop_at)
  local path = require("lspconfig/util").path

  if type(prefixes) == "string" then
    prefixes = { prefixes }
  end

  local found
  for _, prefix in ipairs(prefixes) do
    local full_cmd = prefix and path.join(prefix, cmd) or cmd
    local possibility

    -- if start_from is a dir, test it first since transverse will start from its parent
    if start_from and path.is_dir(start_from) then
      possibility = path.join(start_from, full_cmd)
      if vim.fn.executable(possibility) > 0 then
        found = possibility
        break
      end
    end

    path.traverse_parents(start_from, function(dir)
      possibility = path.join(dir, full_cmd)
      if vim.fn.executable(possibility) > 0 then
        found = possibility
        return true
      end
      -- use cwd as a stopping point to avoid scanning the entire file system
      if stop_at and dir == stop_at then
        return true
      end
    end)

    if found ~= nil then
      break
    end
  end

  return found or cmd
end


M.get_python_path = function(workspace)
    path = lsp_util.path
    -- Use activated venv
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    -- Find virtualenv in workspace
    return M.find_cmd("python", "venv/bin", workspace)

    -- Find and use virtualenv in workspace directory
    -- for _, pattern in ipairs({'*', '.*'}) do
    --     local match = vim.fn.glob(path.join(workspace, pattern, 'venv'))
    --     if match ~= '' then
    --         vim.inspect(p)
    --         p = path.join(path.dirname(match), 'bin', 'python')
    --         return p
    --     end
    -- end

    -- Fallback to system Python (For now prioritize Python 2, due to work)
    -- return exepath('python') or exepath('python3') or 'python'
end


return M
