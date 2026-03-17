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

syntax enable
filetype plugin indent on

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
endif

nnoremap J 10j
nnoremap K 10k

vnoremap J 10j
vnoremap K 10k
