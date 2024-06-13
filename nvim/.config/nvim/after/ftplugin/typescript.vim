set cms=//\ %s

set tabstop=2 " number of spaces to move by when pressing <TAB>
set shiftwidth=2
set softtabstop=2

:iabbrev <buffer> iff if ()<left>

lua <<EOF

ts_lsp_config = {
    name = 'typescript-ls',
    cmd = { 'typescript-language-server', '--stdio' },
    on_attach = lsp_attach
}

EOF

call luaeval('start_lsp(ts_lsp_config)')


augroup ts_format
    autocmd!
    autocmd BufWritePost <buffer> :silent lua vim.lsp.buf.format()
augroup end
