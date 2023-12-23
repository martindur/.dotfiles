
"nnoremap <buffer> gc I#<esc>

lua << EOF
elixir_lsp_config = {
    name = 'elixir-ls',
    cmd = { 'elixir-ls' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'mix.exs' }, { upward = true })[1]),
    on_attach = lsp_attach
    --on_attach = function(client, buf)
    --    print('hi from elixir')
    --    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf })
    --    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = buf })
    --end
}
EOF

call luaeval('start_lsp(elixir_lsp_config)')

lua vim.treesitter.start()

augroup elixir_format
    autocmd!
    autocmd BufWritePost <buffer> :silent execute '!mix format '.bufname("%")
augroup end

