set cms=#\ %s

:iabbrev <buffer> pp \|>
:iabbrev <buffer> xc <%= %><left><left><left>
:iabbrev <buffer> xx <% %><left><left><left>
:iabbrev <buffer> hh ~H"""<cr>"""<up><right><right><cr>

lua << EOF
elixir_lsp_config = {
    name = 'elixir-ls',
    cmd = { 'elixir-ls' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'mix.exs' }, { upward = true })[1]),
    on_attach = lsp_attach
}

next_ls_config = {
    name = 'next-ls',
    cmd = { 'nextls', '--stdio' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'mix.exs' }, { upward = true })[1]),
    on_attach = lsp_attach,
    settings = {
        experimental = {
            completions = {
                enable= true
            }
        }
    }
}

EOF

call luaeval('start_lsp(elixir_lsp_config)')

augroup elixir_format
    autocmd!
    autocmd BufWritePost <buffer> :silent execute '!mix format '.bufname("%")
augroup end
