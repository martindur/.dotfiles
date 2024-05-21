set cms=#\ %s

:iabbrev <buffer> iff if:<left>

lua <<EOF

local function get_root_dir()
    return vim.fs.dirname(vim.fs.find({ 'requirements.txt', 'pyproject.toml', '.venv', '.git' }, { upward = true })[1])
end

local function get_venv()
    local root_dir = get_root_dir()
    if root_dir then
        return root_dir .. "/.venv/bin/python"
    end

    return ""
end

pyright_lsp_config = {
    name = 'pyright-ls',
    cmd = { 'pyright-langserver', '--stdio' },
    on_attach = lsp_attach,
    root_dir = get_root_dir(),
    settings = {
        pyright = {
            -- Using ruff's import organizer
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                --autoSearchPaths = true,
                --diagnosticMode = "workspace",
                --useLibraryCodeForTypes = true,

                -- ignore all files for analysis in favor of ruff
                ignore = { '*' }
            },
            pythonPath = get_venv()
        },
    }
}

ruff_lsp_config = {
    name = 'ruff-ls',
    cmd = { 'ruff-lsp' },
    on_attach = lsp_attach,
    root_dir = get_root_dir(),
}


EOF

call luaeval('start_lsp(pyright_lsp_config)')
call luaeval('start_lsp(ruff_lsp_config)')


augroup python_format
    autocmd!
    autocmd BufWritePost <buffer> :silent lua vim.lsp.buf.format()
augroup end
