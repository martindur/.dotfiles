set cms=//\ %s

set shiftwidth=2
set tabstop=2

:iabbrev <buffer> pp \|>

lua << EOF

-- LSP

gleam_lsp_config = {
    name = 'gleam-ls',
    cmd = { 'gleam', 'lsp' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'gleam.toml', '.git' }, { upward = true })[1]),
    on_attach = lsp_attach
}

EOF

call luaeval('start_lsp(gleam_lsp_config)')

augroup gleam_format 
    autocmd!
    autocmd BufWritePost <buffer> :silent lua vim.lsp.buf.format()
augroup end
