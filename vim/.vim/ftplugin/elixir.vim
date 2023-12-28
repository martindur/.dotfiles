
nnoremap <buffer> gc I#<esc>

augroup format
    autocmd!
    autocmd BufWritePost <buffer> :silent execute '!mix format '.bufname("%")
augroup end
