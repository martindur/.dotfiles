local util = require('util')

vim.g.mapleader = " "

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.completeopt = { 'menu', 'popup', 'noinsert', 'fuzzy' }

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true

-- Use ripgrep for :grep command
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Jump to quickfix results in another window automatically
vim.opt.switchbuf = "useopen,uselast"

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true

vim.opt.wildignore = { '__pycache__', 'node_modules' }
vim.opt.listchars = { space = '_', tab = '>~' }


---------
-- LSP --
---------

require('lsp').setup()


-- LSP AUTO COMPLETE --

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set('n', 'gr', function() require('fzf-lua').lsp_references() end,
      { buffer = args.buf, desc = "LSP references" })
  end
})

-- KEY MAP --

vim.keymap.set({ 'n', 'v' }, 'J', '10j')
vim.keymap.set({ 'n', 'v' }, 'K', '10k')
vim.keymap.set('i', 'jk', '<esc>')

-- Search with word under cursor pre-filled
vim.keymap.set('n', '/', function()
  local word = vim.fn.expand('<cword>')
  if word ~= '' then
    vim.fn.feedkeys('/' .. word, 'n')
  else
    vim.fn.feedkeys('/', 'n')
  end
end)

-- Grep word under cursor and open quickfix
vim.keymap.set('n', 'g/', function()
  local word = vim.fn.expand('<cword>')
  if word ~= '' then
    vim.cmd('silent grep! ' .. vim.fn.shellescape(word))
    vim.cmd('copen')
  else
    vim.notify('No word under cursor', vim.log.levels.WARN)
  end
end)

-- Auto-navigate when moving in quickfix window
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', 'j', 'j<cr><c-w>p', { buffer = true })
    vim.keymap.set('n', 'k', 'k<cr><c-w>p', { buffer = true })
  end
})


-- File finding --
vim.keymap.set({ 'n' }, '<leader>g', function() util.floating_process('lazygit', { width = 1, height = 1 }) end)

-- NOTE: Disabling yazi for now, to test out oil exclusively
-- vim.keymap.set({ 'n' }, '<leader>e', function()
--   local dir = vim.fn.expand('%:p:h')
--   if dir == '' then dir = vim.loop.cwd() end
--   util.floating_process('yazi "' .. dir .. '"')
-- end)
vim.keymap.set({ 'n' }, '<leader>e', '<cmd>Oil --float<cr>')

vim.keymap.set({ 'n' }, '<leader>1', '<cmd>tabn 1<cr>')
vim.keymap.set({ 'n' }, '<leader>2', '<cmd>tabn 2<cr>')
vim.keymap.set({ 'n' }, '<leader>3', '<cmd>tabn 3<cr>')
vim.keymap.set({ 'n' }, '<leader>4', '<cmd>tabn 4<cr>')
vim.keymap.set({ 'n' }, '<leader>5', '<cmd>tabn 5<cr>')

vim.keymap.set({ 't' }, '<c-x>', '<c-\\><c-n>')

-- FUNCTIONALITY --

-- search git log (keeps the selected item while searching, provided it matches):
-- git log --oneline --graph --color=always | nl | fzf --ansi --track --no-sort --layout=reverse-list

-- search (and execute?) command history:
-- history | fzf --tac --no-sort

-- TODO:
-- * quick open terminal (toggleable?)
-- * simple which key
-- * consolidate themes (keep habamax?)
-- * AI buffer v1 (simple buffer chat)
-- * AI buffer v2 (context via vectorized database of code, using pgvector)
--

-- PLUGINS

vim.cmd('source ' .. vim.fn.stdpath("config") .. '/plugme.vim')


require('oil').setup({
  keymaps = {
    ["q"] = { "actions.close", mode = "n" },
  }
})

require('tokyonight').setup({
  transparent = true
})
vim.cmd.colorscheme("tokyonight")

-- require('nvim-treesitter.configs').setup({
--   highlight = { enable = true }
-- })


local fzflua = require('fzf-lua')
fzflua.setup({
  "hide", -- hide the fzf process when closing, for a better resume experience
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
  files = {
    fd_opts = "--color=never --type f --hidden --follow --exclude .git",
  },
  buffers = {
    cwd_only = true,
    -- no_term_buffers = false
    -- current_tab_only = true,
    show_unlisted = true,
    show_unloaded = true
  }
})

vim.keymap.set({ 'n' }, '<leader>f', fzflua.files, { desc = "find project files with fzf" })
vim.keymap.set({ 'n' }, '<leader>b', fzflua.buffers, { desc = "find files from current buffers" })
vim.keymap.set({ 'n' }, '<leader>t', fzflua.tabs, { desc = "switch tabs" })
-- vim.keymap.set({ 'n' }, '<leader>F', peekaboo.find_files_include_hidden, { desc = "find files, including hidden" })
vim.keymap.set({ 'n' }, '<leader>t', fzflua.live_grep_native,
  { desc = "find files by searching for string in file" })
vim.keymap.set({ 'n' }, '<leader>w', fzflua.grep_cword, { desc = "grep word under cursor" })
vim.keymap.set({ 'n' }, ',', fzflua.resume, { desc = "re-run last query" })

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
  underline = { severity = { min = vim.diagnostic.severity.ERROR } },
  signs = { severity = { min = vim.diagnostic.severity.WARN } },
})

-- TROUBLE (DIAGNOSTICS)
require('trouble').setup({
  win = { position = "right" },
  modes = {
    diagnostics = {
      filter = { severity = vim.diagnostic.severity.ERROR },
    },
  },
})
vim.keymap.set('n', '<leader>dd', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Workspace diagnostics" })
vim.keymap.set('n', '<leader>db', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = "Buffer diagnostics" })
vim.keymap.set('n', '<leader>ds', '<cmd>Trouble symbols toggle<cr>', { desc = "Document symbols" })


-- Diff view
require('diff').setup()


-- CHECKS --

vim.api.nvim_create_user_command("RuffCheck", function()
  vim.cmd("cexpr system('uv run ruff check --output-format=concise --select=F .')")
  vim.cmd("copen")
end, {})


-- CONFORM (FORMATTING) --
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    astro = { "prettierd", "prettier", stop_after_first = true },
    svelte = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback"
  }
})


-- SNACKS --
require('snacks').setup({
  picker = { enabled = true },
  gh = { enabled = true }
});

vim.keymap.set('n', '<leader>pr', function()
  Snacks.picker.gh_pr()
end)


-- AUTOCOMPLETION --
require('blink.cmp').setup()

-- OTHER --
-- PROJECTS --
-- require('projects').setup({
--   pick = { root = vim.fn.expand('~') .. '/projects', depth = 1 },
--   set_tabline = true
-- })
--
-- vim.keymap.set('n', '<leader>pp', function() require('projects').pick() end)
-- vim.keymap.set('n', '<leader>pr', function()
--   vim.ui.input({ prompt = 'Rename tab:' }, function(name)
--     if name then require('projects').rename(name) end
--   end)
-- end)
