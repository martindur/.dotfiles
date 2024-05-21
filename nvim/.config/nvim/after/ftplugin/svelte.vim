set cms=//\ %s

:iabbrev <buffer> iff if ()<left>

lua <<EOF

local function get_root_dir()
    return vim.fs.dirname(vim.fs.find({ 'package.json', 'svelte.config.js'}, { upward = true })[1])
end

svelte_lsp_config = {
    name = 'svelte-ls',
    cmd = { 'svelteserver', '--stdio' },
    on_attach = lsp_attach,
    root_dir = get_root_dir(),
}

EOF

call luaeval('start_lsp(svelte_lsp_config)')


augroup svelte_format
    autocmd!
    autocmd BufWritePost <buffer> :silent lua vim.lsp.buf.format()
augroup end
