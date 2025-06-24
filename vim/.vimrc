vim9script

# Enable modern Vim features
set nocompatible

# enable default fzf integration
set rtp+=/opt/homebrew/opt/fzf

# Sane defaults
set number         # Show line numbers
set relativenumber # Show relative line numbers
set hidden         # Allow switching buffers without saving
set mouse=a        # Enable mouse support
set updatetime=300 # Faster completion
set timeoutlen=500 # Faster key sequence completion
set signcolumn=yes # Always show signcolumn
set laststatus=2

# Search settings
set ignorecase     # Case-insensitive search
set smartcase      # Case-sensitive if search contains uppercase
set incsearch      # Incremental search
set hlsearch       # Highlight search results

# Indentation
set expandtab      # Use spaces instead of tabs
set shiftwidth=2   # Size of indent
set tabstop=2      # Size of tab
set smartindent    # Smart autoindenting

# UI improvements
set cursorline     # Highlight current line
set showmatch      # Show matching brackets
set wildmenu       # Command-line completion
set wildmode=longest:full,full
set scrolloff=8    # Keep cursor centered
set sidescrolloff=8
set splitright     # Open new splits to the right
set splitbelow     # Open new splits below

set title          # Display title in terminal

set clipboard=unnamed

colorscheme habamax

g:mapleader = " "

# Syntax
syntax enable
filetype plugin indent on


# Basic file finding (using built-in functionality)
# Use :find and :b for file navigation
set path+=**       # Search down into subfolders
set wildignore+=**/node_modules/**,**/.git/**

# Basic grep functionality
# Use :vimgrep for searching
command! -nargs=1 Grep execute 'silent grep! <args>' | copen
nnoremap <Leader>* :grep! "\b<c-r><c-w>\b"<CR>:cw<CR>

# Use ripgrep if available
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
endif


# Enter terminal-normal mode
# Consider setting a good 'termwinkey' which is the
# prefix key for terminal (default c-w)
tnoremap <c-x> <c-w>N

nnoremap J 10j
nnoremap K 10k

vnoremap J 10j
vnoremap K 10k
