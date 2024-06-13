set cms=--\ %s

set shiftwidth=2
set tabstop=2

lua << EOF
lua_lsp_config = {
    name = 'lua-ls',
    cmd = { 'lua-language-server' },
    on_attach = lsp_attach,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                checkThirdParty= false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        }
    }
}
EOF

call luaeval('start_lsp(lua_lsp_config)')

augroup lua_format
    autocmd!
    autocmd BufWritePost <buffer> :silent lua vim.lsp.buf.format()
augroup end
