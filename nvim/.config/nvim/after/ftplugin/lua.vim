set cms=--\ %s

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
