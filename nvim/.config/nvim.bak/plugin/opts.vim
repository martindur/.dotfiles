set nocompatible
filetype off

syntax on
set termguicolors

filetype plugin indent on

set nocompatible
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set backspace=indent,eol,start
set autoindent
set copyindent

set shiftround
set showmatch
set matchtime=2

set ignorecase
set smartcase
set smarttab

set hlsearch
set incsearch

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

set completeopt=menu,menuone,popup,fuzzy
set foldenable
set foldlevel=99
set foldmethod=foldexpr
set foldexpr=v:lua.vim.treesitter.foldexpr()

set laststatus=2
set cursorline

set autoread

set timeoutlen=1000
set ttimeoutlen=0

set splitright
