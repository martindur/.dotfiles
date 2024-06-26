" OPTIONS

set textwidth=80

" set nocompatible
" filetype off
let mapleader = " "

" syntax on
set termguicolors

filetype plugin indent on

set tabstop=4 " number of spaces to move by when pressing <TAB>
set shiftwidth=4
set expandtab
set softtabstop=4
" set backspace=indent,eol,start
set autoindent
set copyindent

set shiftround
set showmatch
set matchtime=2 " 2/10th of a second for 'showmatch' to show the matched bracket

set ignorecase
set smartcase
" set smarttab

set hlsearch " highlight search hits
" set incsearch " show matches for searches incrementally (e.g. while typing pattern) - this is incredibly useful for regex

" set history=1000
set undolevels=1000

set number
set relativenumber

set clipboard^=unnamedplus

set title
" set ruler
set novisualbell
set noerrorbells

set so=7
set hidden

" set laststatus=2
set cursorline

" set autoread " this will reload files that were written to from external programs (e.g. useful for formatters)

" set timeoutlen=1000 " the timeout length between key combinations
set ttimeoutlen=0 " the timeout for key code delays. IMPORTANT: This may be a culprit for mappings that include keys like Esc

" should just be for mac
if system('uname') =~ "Darwin"
    set rtp+=/usr/local/opt/fzf
else
    set rtp+=/etc/profiles/per-user/dur/share/vim-plugins/fzf
endif

" MAPPINGS

nnoremap J 10j
nnoremap K 10k

vnoremap J 10j
vnoremap K 10k

" move selection down by 1
vnoremap <PageDown> :m '>+1<CR>gv=gv
" move selection up by 1
vnoremap <PageUp> :m '<-2<CR>gv=gv

" quick save
nnoremap <Leader>w :w<CR>


" COMMENTING:

augroup commenting
    autocmd!
    autocmd FileType python nnoremap <buffer> gc I#<esc>
    autocmd FileType javascript,typescript nnoremap <buffer> gc I//<esc>
augroup end

augroup conditionals_shorthand
    autocmd!
    autocmd FileType python     :iabbrev <buffer> iff if:<left>
    autocmd FileType javascript :iabbrev <buffer> iff if ()<left>
augroup end

" Vimscript file settings {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup end
" }}}

au BufRead,BufWrite *.heex set filetype=eelixir

"command! MixFormat :silent execute "

"nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>

" surround current word with "
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel

inoremap jk <esc>
" I might hate myself for doing this, but learning the hard way is the fast
" way
inoremap <esc> <nop>

" operator mapping, e.g. run di( with dp, or ci( with cp
" wunderbar!!
onoremap p i(

" db -> delete body, e.g. delete up until return (useful in most filetypes,
" but might want to make a custom one for elixir
onoremap b /return<cr>

" FUZZY FINDING:

" fzf comes with some native git integration functions - no need for plugin
" source: the input source for fzf, e.g. like git ls-files | fzf
" sink: the action to take on the returned input, e.g. :e (edit)
nnoremap <leader>f :call fzf#run({
"\    'source': 'git ls-files -cmo --exclude-standard',
\    'source': 'rg --files --hidden',
"\    'source': 'rg --files --type elixir',
\    'sink': 'e',
\    'window': {'width': 0.9, 'height': 0.7},
\    'options': '--preview "bat --color=always --style=numbers --line-range=:500 {}"'
\})<CR>

command! -nargs=* Rg call s:rg_fzf(<q-args>)

function! s:sink(...)
    let [path, line, column] = split(a:1, ':')[:2]

    execute ':e ' . path
    execute line
endfunction

function! s:rg_fzf(query)
    let qry = empty(a:query) ? '' : a:query

    let rg = 'rg --column --line-number --no-heading --color=always --smart-case'
    let preview = '--delimiter : --preview "bat --color=always {1} --highlight-line {2}"'

    let options = '--ansi --disabled --query "'.qry.'" --bind "start:reload:'.rg.' {q}" --bind "change:reload:sleep 0.01; '.rg.' {q} || true" '.preview
    let fzf_cmd = {'source': ':', 'sink': function('s:sink'), 'window': {'width': 0.9, 'height': 0.7}, 'options': options}
    
    call fzf#run(fzf_cmd)
endfunction

nnoremap <leader>ss :Rg<CR>
nnoremap <leader>sw :execute 'Rg ' . expand('<cword>')<CR>


call plug#begin('~/vimplugins')
    Plug 'tpope/vim-sensible'
    " File explorer
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-commentary'

    " LSP
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'

    " Completion
    Plug 'lifepillar/vim-mucomplete'

    " colorscheme
    Plug 'EdenEast/nightfox.nvim'
    Plug 'dracula/vim', { 'as': 'dracula' }

    " Gleam
    " Plug 'gleam-lang/gleam.vim'
call plug#end()

" mu-complete settings

set completeopt+=menuone
set completeopt+=noselect
let g:mucomplete#enable_auto_at_startup = 1
set complete-=i
set complete-=t
set shortmess+=c
set belloff=all

let g:mucomplete#wordlist = {
    \ '': ['Hello, world!'],
\}

let g:mucomplete#chains = {}
let g:mucomplete#chains['default'] = {
    \ 'default': ['list', 'omni', 'path', 'c-n', 'uspl'],
    \ '.*string.*': ['uspl'],
    \ '.*comment.*': ['uspl']
\}


colorscheme nightfox 

let g:lsp_settings = {
\    "elixir-ls": {
\        "dialyzerEnabled": v:false
\    }
\   }


function! g:StartLsp()
    function! OnLspBufferEnabled() abort
        setlocal omnifunc=lsp#complete
        setlocal signcolumn=yes
        nmap <buffer> gd <plug>(lsp-definition)
        nmap <buffer> gs <plug>(lsp-document-symbol-search)
        nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
        nmap <buffer> gh <plug>(lsp-hover)
        nmap <buffer> gr <plug>(lsp-references)
        nmap <buffer> <leader>rn <plug>(lsp-rename)
    endfunction

    augroup lsp_install
        au!
        autocmd User lsp_buffer_enabled call OnLspBufferEnabled()
    augroup END
endfunction

function! SpawnInFloatTerm(cmd)
    let buf = term_start(a:cmd, #{hidden: 1, term_finish: 'close'})
    let winid = popup_create(buf, #{minwidth: 200, minheight: 100})
endfunction

nnoremap <silent> <leader>g :call SpawnInFloatTerm(['lazygit'])<CR>
nnoremap <silent> <leader>e :call SpawnInFloatTerm(['yazi'])<CR>


" TO DO:
" * fuzzy search git branches and checkout -> git branch | fzf | xargs git
" checkout
" * ripgrep -> fuzzy find words through project

" when doing 'find', include subfolders
set path+=**

" display all matching files when we tab complete
" set wildmenu
set wildcharm=<TAB>     " needed to open the wildmenu from shortcuts
set wildignore=*.swp,*.bak,*.pyc,*.erl,*.hrl


" NOW WE CAN:
" use `find *.ex` to find all .ex files recursively searching from pwd
" on tab completion, retrieve a list of results

" TAG JUMPING

" jump back: C-o
" jump ahead: C-i

let g:default_ctags_exclude = '--exclude=.git --exclude="*.css" --exclude="*.mk" --exclude="*.html" --exclude="*.beam" --exclude="*.md" --exclude="*.json" --exclude="*.erl" --exclude="Makefile" --exclude="*.pyc" --exclude=__pycache__ --exclude=.cache --exclude=node_modules --exclude="*.txt"'
" create the `tags` file (may need to install ctags first)
"command! MakeTags execute '!ctags ' . g:default_ctags_exclude . ' -R .'

"nnoremap gd <C-]>
"nnoremap gb <C-t>

" SNIPPETS

" Read an empty HTML template and move cursor to title
nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a
