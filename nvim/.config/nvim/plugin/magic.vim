
" Operators

onoremap <silent> F :<C-U>normal! 0f(hviw<CR>

" operator mapping, e.g. run di( with dp, or ci( with cp
" wunderbar!!
onoremap <silent> p i(

" db -> delete body, e.g. delete up until return (useful in most filetypes,
" but might want to make a custom one for elixir
onoremap <silent> b /return<cr>


" EXTERNAL APPS - FLOATING TERMINAL

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
nnoremap <silent> <leader>e :call SpawnInFloatTerm(['yazi'])<CR>

function! TabOrRight()
    if search('\%#[]>)}''"]', 'n')
        return "\<right>"
    endif

    return "\<tab>"
endfunction

inoremap <expr> <Tab> TabOrRight()

function! NextLineWithEmptySpace()
    let l:save_search = @/

    execute 'normal! /\(^\n\)\@<=^.\<CR>'

    let @/ = l:save_search
endfunction

" nnoremap <leader>j :/\v^\s*$<cr>:nohlsearch<cr>
nnoremap j :/\v\S<cr>:nohlsearch<cr>
nnoremap k :?\v\S<cr>:nohlsearch<cr>


" QUICKFIX

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
