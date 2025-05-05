
call plug#begin('~/nvimplugins')
    Plug 'nvim-lua/plenary.nvim'
    Plug 'olimorris/codecompanion.nvim'
    "Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    "Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'folke/snacks.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'rebelot/kanagawa.nvim'
    Plug 'saghen/blink.cmp', { 'tag': '*' }
call plug#end()

colorscheme kanagawa

let mapleader = " "

"TODO: add ftplugins (and maybe ft specific abbreviations?)
"TODO: Consider using blink.cmp - it supports vim.snippet api
"(https://github.com/saghen/blink.cmp)
"TODO: Get a cup of coffee, and figure out how powerful telescope can be for
"me!


nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

inoremap jk <esc>

" panes
nnoremap <C-m> <cmd>vsplit term://zsh<cr>i
nnoremap <C-u> <cmd>split term://zsh<cr>i
nnoremap <C-q> :q<cr>
tnoremap <C-q> <C-\><C-n>:q<cr>
tnoremap <C-x> <C-\><C-n>

" Telescope
"nnoremap <leader>f <cmd>Telescope find_files hidden=true<cr>
""nnoremap <leader>. <cmd>Telescope find_files hidden=true<cr>
"nnoremap <leader>h <cmd>Telescope help_tags<cr>
"nnoremap <leader>c <cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })<cr>
"nnoremap <leader>b <cmd>Telescope buffers<cr>
""nnoremap <leader>t <cmd>Telescope live_grep<cr>


lua <<EOF
-- require('core.lsp')
require('core.statusline')

-- require('extras.multigrep').setup()

vim.keymap.set({'t', 'i'}, '<C-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set({'t', 'i'}, '<C-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set({'t', 'i'}, '<C-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set({'t', 'i'}, '<C-l>', '<C-\\><C-N><C-w>l')

vim.keymap.set({'n', 'v'}, '<C-l>', '<C-w>l')
vim.keymap.set({'n', 'v'}, '<C-k>', '<C-w>k')
vim.keymap.set({'n', 'v'}, '<C-j>', '<C-w>j')
vim.keymap.set({'n', 'v'}, '<C-h>', '<C-w>h')

vim.keymap.set({'n', 'v'}, 'J', '10j')
vim.keymap.set({'n', 'v'}, 'K', '10k')

vim.keymap.set({'n', 'v', 'i', 't'}, '<A-Right>', '<cmd>vertical resize +5<cr>')
vim.keymap.set({'n', 'v', 'i', 't'}, '<A-Left>', '<cmd>vertical resize -5<cr>')
vim.keymap.set({'n', 'v', 'i', 't'}, '<A-Up>', '<cmd>horizontal resize -5<cr>')
vim.keymap.set({'n', 'v', 'i', 't'}, '<A-Down>', '<cmd>horizontal resize +5<cr>')

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end
})

require('blink.cmp').setup()

require('codecompanion').setup()

require('snacks').setup({
  picker = { enabled = true }
})

-- require('telescope').load_extension('fzf')
-- require('telescope').setup({
--   pickers = {
--     find_files = {
--       theme = "ivy"
--     }
--   },
--   extensions = {
--     fzf = {}
--   }
-- })


require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "lua", "vim", "vimdoc", "javascript", "typescript", "svelte", "html",
    "css", "python", "markdown", "sql"
  },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true }
})


EOF
