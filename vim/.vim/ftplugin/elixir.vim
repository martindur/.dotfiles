
nnoremap <buffer> gc I#<esc>

call StartLsp()

augroup format
    autocmd!
    autocmd BufWritePost <buffer> :silent execute '!mix format '.bufname("%")
augroup end
