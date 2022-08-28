local M = {}

local function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

M.nmap = bind("n", {noremap = false})
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

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


return M
