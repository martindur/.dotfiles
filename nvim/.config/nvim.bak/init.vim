colorscheme onedark

call plug#begin('~/vimplugins')
    " base
    Plug 'nvim-lua/plenary.nvim'
    " telescope
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    " treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " lspconfig
    Plug 'neovim/nvim-lspconfig'
    " completion
    Plug 'Saghen/blink.cmp', { 'tag': '*' }
    Plug 'rafamadriz/friendly-snippets'
call plug#end()


let mapleader = " "


tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l

nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h

vnoremap <C-l> <C-w>l
vnoremap <C-k> <C-w>k
vnoremap <C-j> <C-w>j
vnoremap <C-h> <C-w>h

nnoremap J 10j
nnoremap K 10k

vnoremap J 10j
vnoremap K 10k

nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

inoremap jk <esc>

" panes
nnoremap <C-m> <cmd>vsplit term://zsh<cr>i
nnoremap <C-u> <cmd>split term://zsh<cr>i
nnoremap <C-x> :q<cr>
tnoremap <C-x> <C-\><C-n>:q<cr>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>t <cmd>Telescope live_grep<cr>

lua <<EOF
require('config')
EOF
