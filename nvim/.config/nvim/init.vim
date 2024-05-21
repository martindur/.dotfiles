
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
inoremap <esc> <nop>

" oil.nvim
nnoremap <silent> <leader>e :Oil<cr>


function! SpawnInFloatTerm(cmd)
    "let buf = term_start(a:cmd, #{hidden: 1, term_finish: 'close'})
    let buf = nvim_create_buf(v:false, v:true)
    let win = nvim_open_win(buf, v:true, {
                \ 'relative': 'editor',
    \ 'width': 200,
    \ 'height': 100,
    \ 'col': &columns/ 2 - 100,
    \ 'row': &lines / 2 - 50,
    \ 'border': 'single',
    \ 'style': 'minimal'
    \ })

    call termopen(a:cmd, {'on_exit': {job_id, exit_code, event -> nvim_win_close(win, v:true)}})
    call nvim_command('startinsert')
endfunction

nnoremap <silent> <leader>g :call SpawnInFloatTerm(['lazygit'])<CR>

function! TabOrRight()
    if search('\%#[]>)}''"]', 'n')
        return "\<right>"
    endif

    return "\<tab>"
endfunction

inoremap <expr> <Tab> TabOrRight()

au BufRead,BufWrite *.heex set filetype=eelixir

augroup highlight_yanked_text
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup end

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

function! ToggleLoc()
    if empty(filter(getwininfo(), 'v:val.loclist'))
        lopen
    else
        lclose
    endif
endfunction

nnoremap <silent> qq :call ToggleQuickFix()<cr>
nnoremap <silent> qo :copen<cr>
nnoremap <silent> qc :cclose<cr>

lua <<EOF

require('custom.lsp')
require('custom.cmp')



require("oil").setup()
require'nvim-treesitter.configs'.setup{highlight={enable=true}}

EOF


