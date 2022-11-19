-- Options
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.breakindent = true

-- vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = true

vim.opt.updatetime = 50
vim.wo.signcolumn = 'yes'

vim.opt.colorcolumn='80'

vim.opt.mouse = 'a'
vim.opt.completeopt = 'menuone,noselect'

vim.g.mapleader = " "
vim.g.maplocalleader = ' '

--vim.opt.clipboard = "unnamedplus,unnamed"


local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({higroup='IncSearch', timeout=40,})
  end,
  group = highlight_group,
  pattern = '*',
})


require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}
