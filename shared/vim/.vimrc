vim9script

set nocompatible

set number
set relativenumber

set ignorecase
set smartcase

set expandtab
set shiftwidth=2
set tabstop=2
set smartindent

set splitright
set splitbelow

g:mapleader = " "

set termguicolors
set background=dark

syntax enable
filetype plugin indent on

colorscheme habamax

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
  set grepformat=%f:%l:%c:%m
endif

# Find tag files upward toward the repo root
set tags=./tags;,tags;

# Allow :find to search recursively
set path+=**
set wildignore+=**/.git/**,**/node_modules/**,**/dist/**,**/target/**

augroup terminal
  autocmd!
  autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no
augroup END
