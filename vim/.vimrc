vim9script

set nocompatible
set rtp+=/opt/homebrew/opt/fzf

set number
set relativenumber
set hidden
set mouse=a
set updatetime=300
set timeoutlen=500
set signcolumn=yes
set laststatus=2

set ignorecase
set smartcase
set incsearch
set hlsearch

set expandtab
set shiftwidth=2
set tabstop=2
set smartindent

set cursorline
set showmatch
set wildmenu
set wildmode=longest:full,full
set scrolloff=8
set sidescrolloff=8
set splitright
set splitbelow

set title

set clipboard=unnamed

colorscheme habamax

g:mapleader = " "

syntax enable
filetype plugin indent on

set path+=**
set wildignore+=**/node_modules/**,**/.git/**

command! -nargs=1 Grep execute 'silent grep! <args>' | copen
nnoremap <Leader>* :grep! "\b<c-r><c-w>\b"<CR>:cw<CR>

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
endif

tnoremap <c-x> <c-w>N

nnoremap J 10j
nnoremap K 10k

vnoremap J 10j
vnoremap K 10k
