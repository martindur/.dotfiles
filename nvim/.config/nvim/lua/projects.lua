local M = {}
local uv = vim.uv or vim.loop

local function join(a, b) return (a:gsub('/+$', '')) .. '/' .. b end
local function is_dir(p)
  local s = uv.fs_stat(p); return s and s.type == 'directory'
end
local function basename(p) return (p:gsub('/+$', ''):match('([^/]+)$')) end
local function current_tabnr() return vim.api.nvim_tabpage_get_number(0) end

local function tab_by_number(n)
  for _, t in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.api.nvim_tabpage_get_number(t) == n then return t end
  end
end

local function tab_name(n) return (vim.t[n] and vim.t[n].projects_name) or ('Tab ' .. n) end
local function tab_root(n) return (vim.t[n] and vim.t[n].projects_root) end

local function set_tab(n, root, name)
  vim.t[n].projects_root = root
  vim.t[n].projects_name = name or basename(root)
  vim.cmd('tcd ' .. vim.fn.fnameescape(root))
  vim.cmd('redrawtabline')
end

local function list_projects(root)
  root = root or (vim.fn.expand('~') .. '/projects')
  local cmd = string.format("fd -t d -d 1 . %s", vim.fn.fnameescape(root))
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("fd failed: " .. table.concat(out, '\n'), vim.log.levels.ERROR)
    return {}
  end
  table.sort(out)
  return out
end

function M.open(path)
  if not path or not is_dir(path) then
    vim.notify('Invalid project dir: ' .. tostring(path), vim.log.levels.ERROR)
    return
  end
  set_tab(current_tabnr(), path, basename(path))
end

function M.pick(opts)
  opts = opts or {}
  local ok, fzf = pcall(require, 'fzf-lua')
  if not ok then return vim.notify('fzf-lua not found', vim.log.levels.ERROR) end

  local in_project = tab_root(current_tabnr()) ~= nil

  if in_project then
    -- OPEN MODE: list open projects only
    local items = {}
    for _, t in ipairs(vim.api.nvim_list_tabpages()) do
      local n = vim.api.nvim_tabpage_get_number(t)
      local r = tab_root(n)
      if r then
        table.insert(items, table.concat({ 'OPEN', tostring(n), tab_name(n), r }, '\t'))
      end
    end
    if #items == 0 then
      return vim.notify('No open projects yet. Create a new tab and assign one.', vim.log.levels.INFO)
    end

    fzf.fzf_exec(items, {
      prompt = 'Switch project> ',
      fn_transform = function(e)
        local parts = vim.split(e, '\t', { plain = true })
        local n, name, root = tonumber(parts[2]), parts[3], parts[4]
        local star = (n == current_tabnr()) and ' *' or ''
        return string.format('[open]%s  %d: %s  —  %s', star, n, name, root)
      end,
      actions = {
        ['default'] = function(sel)
          local line = type(sel) == 'table' and sel[1] or sel
          local n = tonumber(vim.split(line, '\t', { plain = true })[2])
          local tp = tab_by_number(n)
          if tp then vim.api.nvim_set_current_tabpage(tp) end
        end,
      },
    })
  else
    -- ASSIGN MODE: list directories under ~/projects (or configured root)
    local roots = list_projects(opts.root, opts.depth or 1)
    if #roots == 0 then
      return vim.notify('No projects found under ' .. (opts.root or (vim.fn.expand('~') .. '/projects')),
        vim.log.levels.WARN)
    end
    -- encode as DIR\t<path> for consistency (even though we don’t need metadata here)
    local items = {}
    for _, p in ipairs(roots) do table.insert(items, ('DIR\t%s'):format(p)) end

    fzf.fzf_exec(items, {
      prompt = 'Open project> ',
      fn_transform = function(e) return (vim.split(e, '\t', { plain = true })[2]) end,
      actions = {
        ['default'] = function(sel)
          local line = type(sel) == 'table' and sel[1] or sel
          local path = vim.split(line, '\t', { plain = true })[2]
          M.open(path)
        end,
      },
    })
  end
end

function M.rename(name)
  if not name or name == '' then return end
  vim.t[current_tabnr()].tabjects_name = name
  vim.cmd('redrawtabline')
end

function M.tabline()
  local s = ''
  for i, t in ipairs(vim.api.nvim_list_tabpages()) do
    local n = vim.api.nvim_tabpage_get_number(t)
    local name = tab_name(n)
    if t == vim.api.nvim_get_current_tabpage() then
      s = s .. '%#TabLineSel# ' .. i .. ':' .. name .. ' %#TabLine#'
    else
      s = s .. '%#TabLine# ' .. i .. ':' .. name .. ' '
    end
  end
  return s .. '%#TabLineFill#%='
end

function M.setup(opts)
  opts = opts or {}
  vim.api.nvim_create_user_command('ProjectOpen', function(cmd) M.open(cmd.args) end, { nargs = 1, complete = 'dir' })
  vim.api.nvim_create_user_command('ProjectPick', function() M.pick(opts.pick) end, {})
  vim.api.nvim_create_user_command('ProjectRename', function(cmd) M.rename(cmd.args) end, { nargs = 1 })

  if opts.set_tabline ~= false then
    vim.o.showtabline = 2
    vim.o.tabline = "%!v:lua.require'projects'.tabline()"
  end

  -- keep cwd synced when re-entering a tabject
  vim.api.nvim_create_autocmd('TabEnter', {
    callback = function()
      local root = tab_root(current_tabnr())
      if root and vim.fn.getcwd() ~= root then
        vim.cmd('tcd ' .. vim.fn.fnameescape(root))
      end
    end,
  })
end

return M
