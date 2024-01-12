-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- a little todo system in markdown files
vim.cmd([[
augroup markdownTodo
    autocmd!

    " Autocmd for Markdown files
    autocmd FileType markdown call SetupMarkdownTodo()

    " Function to setup todo functionality in Markdown
    function! SetupMarkdownTodo()
        " Buffer-local key mapping for the Return key
        nnoremap <silent><buffer><CR> :call ToggleTodo()<CR>
        nnoremap <silent><buffer><BS> <C-t>

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

        inoremap <buffer>tdi ( ) - 
    endfunction
augroup END
]])

vim.cmd([[
augroup ElixirSnippets
  autocmd!
  autocmd FileType elixir :iabbrev <buffer> pp \|>
  autocmd FileType elixir,heex :iabbrev <buffer> xc <%= %><left><left><left>
  autocmd FileType elixir,heex :iabbrev <buffer> xx <% %><left><left><left>
augroup end
]])
