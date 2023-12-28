lua << EOF
python_lsp_config = {
    name = 'pyright-ls',
    cmd = { 'pyright-langserver', '--stdio' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml', 'requirements.txt', '.venv' }, { upward = true })[1]),
    on_attach = lsp_attach
}
EOF

call luaeval('start_lsp(python_lsp_config)')

lua vim.treesitter.start()

"augroup python_format
"    autocmd!
"    autocmd BufWritePost <buffer> :silent execute '!mix format '.bufname("%")
"augroup end
