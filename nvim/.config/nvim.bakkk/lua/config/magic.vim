" Operators

onoremap <silent> F :<C-U>normal! 0f(hviw<CR>

" operator mapping, e.g. run di( with dp, or ci( with cp
" wunderbar!!
onoremap <silent> p i(

" find a better mapping, t is used for e.g. delete to x
" onoremap <silent> t i"

" db -> delete body, e.g. delete up until return (useful in most filetypes,
" but might want to make a custom one for elixir
onoremap <silent> b /return<cr>


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


" Jumps over white space
" nnoremap j :/\v\S<cr>:nohlsearch<cr>
" nnoremap k :?\v\S<cr>:nohlsearch<cr>


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
