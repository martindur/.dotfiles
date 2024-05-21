" Buffer-local key mapping for the Return key
nnoremap <silent><buffer><CR> :call ToggleTodo()<CR>
nnoremap <silent><buffer><BS> <C-t>

inoremap <buffer>tdi ( ) - 

" Function to toggle todo items
function! ToggleTodo()
    " Get the current line
    let l:line = getline('.')

    " Check if the line contains a Markdown link pattern like [text](#anchor)
    if l:line =~ '\[.*\]\(#.*\)'
        echo 'spot on!'
        execute 'lua:vim.lsp.buf.definition()'
    " Check if the line starts with ( ) or (x) and toggle
    elseif l:line =~ '^\s*( )'
        " Toggle from incomplete to complete
        let l:newLine = substitute(l:line, '^\(\s*\)( )', '\1(x)', '')
    elseif l:line =~ '^\s*(x)'
        " Toggle from complete to incomplete
        let l:newLine = substitute(l:line, '^\(\s*\)(x)', '\1( )', '')
    else
        " If not a todo item, return without changing
        echo 'nothing here'
        return
    endif

    " Set the modified line
    call setline('.', l:newLine)
endfunction


