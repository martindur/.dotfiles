" OPTIONS

set nocompatible
filetype off
let mapleader = " "

syntax on
set termguicolors
colorscheme onedark

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

set laststatus=2
set cursorline

set timeoutlen=1000 " the timeout length between key combinations
set ttimeoutlen=0 " the timeout for key code delays. IMPORTANT: This may be a culprit for mappings that include keys like Esc

" MAPPINGS

nmap J 10j
nmap K 10k

vmap J 10j
vmap K 10k

" move selection down by 1
vmap <PageDown> :m '>+1<CR>gv=gv
" move selection up by 1
vmap <PageUp> :m '<-2<CR>gv=gv

" quick save
nmap <Leader>w :w<CR>


" FUZZY FINDING:

" fzf comes with some native git integration functions - no need for plugin
" source: the input source for fzf, e.g. like git ls-files | fzf
" sink: the action to take on the returned input, e.g. :e (edit)
nnoremap <leader>f :call fzf#run({
\    'source': 'git ls-files -cmo --exclude-standard',
\    'sink': 'e',
\    'window': {'width': 0.9, 'height': 0.7},
\    'options': '--preview "bat --color=always --style=numbers --line-range=:500 {}"'
\})<CR>

command! -nargs=* Rg call s:rg_fzf(<q-args>)

function! s:rg_fzf(query)
    let cmd = 'rg --column --line-number --no-heading --color=always --smart-case --'.shellescape(a:query)
    let result = systemlist(cmd)
    if empty(result)
        echo "No matches found."
        return
    endif

    let choice = fzf#run(result)
    if empty(choice)
        echo "Search canceled."
        return
    endif

    let parts = split(choice, ":")
    let filename = parts[0]
    let line_number = parts[1]
    execute 'edit ' . filename
    execute line_number
endfunction

" TO DO:
" * fuzzy search git branches and checkout -> git branch | fzf | xargs git
" checkout
" * ripgrep -> fuzzy find words through project

" when doing 'find', include subfolders
set path+=**

" display all matching files when we tab complete
set wildmenu
set wildcharm=<TAB>     " needed to open the wildmenu from shortcuts
set wildignore=*.swp,*.bak,*.pyc,*.erl,*.hrl


" NOW WE CAN:
" use `find *.ex` to find all .ex files recursively searching from pwd
" on tab completion, retrieve a list of results

" TAG JUMPING

" jump back: C-o
" jump ahead: C-i

" create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

nnoremap gd <C-]>
nnoremap gb <C-t>

" NOW WE CAN:
" - use C-] to jump to tag under cursor
" - use g+C-] for ambiguous tags
" - use C-t to jump back up the tag stack

" THINGS TO CONSIDER:
" - this doesn't help if you want a visual list of tags

" AUTOCOMPLETE

" works 'out of the box' with tags

" NOW WE CAN:
" - use C-x C-n for JUST this file
" - use C-x C-f for filenames
" - use C-x C-] for tags only
" - use C-n for anything specified by the 'complete' option
" - use C-n and C-p to go back and fourth between suggestions

" FILE BROWSING:

let g:netrw_banner=0 		" disable annoying banner
let g:netrw_browse_split=4 	" open in prior window
let g:netrw_winsize=15
"let g:netrw_altv=1 		" open splits to the right
let g:netrw_liststyle=3		" tree view
"let g:netrw_list_hide=netrw_gitignore#Hide()
"let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" open netrw filebrowser
nmap <leader>e :Lexplore<CR> 

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings

" SNIPPETS

" Read an empty HTML template and move cursor to title
nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a
