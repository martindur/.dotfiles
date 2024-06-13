
" Plugin manager
call plug#begin('~/vimplugins')
    Plug 'tpope/vim-commentary' " set commentstring in ftplugin
    Plug 'EdenEast/nightfox.nvim' " color theme
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'stevearc/oil.nvim'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'mfussenegger/nvim-dap'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'nvim-neotest/nvim-nio' " nvim-dap-ui dependency
    Plug 'theHamsta/nvim-dap-virtual-text'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    Plug 'nvim-pack/nvim-spectre'
call plug#end()


" OPTIONS

set nocompatible
filetype off

syntax on
set termguicolors
colorscheme nightfox

filetype plugin indent on

set tabstop=4 " number of spaces to move by when pressing <TAB>
set shiftwidth=4
set expandtab
set softtabstop=4
set backspace=indent,eol,start
set autoindent
set copyindent

set shiftround
set showmatch
set matchtime=2 " 2/10th of a second for 'showmatch' to show the matched bracket

set ignorecase
set smartcase
set smarttab

set hlsearch " highlight search hits
set incsearch " show matches for searches incrementally (e.g. while typing pattern) - this is incredibly useful for regex

set history=1000
set undolevels=1000

set number
set relativenumber

set clipboard^=unnamedplus

set title
set ruler
set novisualbell
set noerrorbells

set so=7
set hidden

set completeopt=menu,menuone,noselect

set laststatus=2
set cursorline

set autoread " this will reload files that were written to from external programs (e.g. useful for formatters)

set timeoutlen=1000 " the timeout length between key combinations
set ttimeoutlen=0 " the timeout for key code delays. IMPORTANT: This may be a culprit for mappings that include keys like Esc


" MAPPINGS
let mapleader = " "

nnoremap J 10j
nnoremap K 10k

vnoremap J 10j
vnoremap K 10k

nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

inoremap jk <esc>
" inoremap <esc> <nop>

	
" oil.nvim
" nnoremap <silent> <leader>e :Oil<cr>


augroup highlight_yanked_text
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup end


nnoremap <leader>F <cmd>Spectre<cr>

" Fuzzy finder
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>s <cmd>Telescope live_grep<cr>

lua <<EOF

require('custom.lsp')
require('custom.cmp')

require('dapui').setup()

require("oil").setup()
require'nvim-treesitter.configs'.setup{highlight={enable=true}}

EOF


