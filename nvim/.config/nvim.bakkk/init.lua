require("config.lazy")
require("config.lsp")
require("config.statusline")
require("config.magic")

vim.cmd [[colorscheme tokyonight-moon]]

-- Keymaps

vim.keymap.set({ 'i' }, 'jk', '<esc>')

vim.keymap.set({ 'n', 'v' }, 'J', '10j')
vim.keymap.set({ 'n', 'v' }, 'K', '10k')

vim.keymap.set({ 'n', 'v' }, '<C-l>', '<C-w>l')
vim.keymap.set({ 'n', 'v' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n', 'v' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n', 'v' }, '<C-h>', '<C-w>h')

vim.keymap.set({ 't' }, '<C-x>', '<C-\\><C-n>')


-- DEV

vim.keymap.set('n', '<leader>pr', function()
  require("plenary.reload").reload_module("pairing")
  vim.cmd([[Lazy reload pairing.nvim]])
  vim.notify("Pairing plugin reloaded!")
end, { desc = 'Reload pairing plugin' })


-- Options

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true -- ignore case in search
vim.opt.smartcase = true  -- override ignorecase when uppercase included
vim.opt.hlsearch = false
vim.opt.wrap = true

vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.termguicolors = true

vim.opt.history = 1000
vim.opt.undolevels = 1000

vim.opt.cursorline = true

vim.opt.splitright = true
vim.opt.splitbelow = true
