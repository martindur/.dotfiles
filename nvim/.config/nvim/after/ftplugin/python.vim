set cms=#\ %s

:iabbrev <buffer> iff if:<left>

lua <<EOF

-- UTIL

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

-- LSP

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

-- DAP

local dap = require('dap')
dap.adapters.python = function(cb, config)
    if config.request == 'attach' then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or '127.0.0.1'
        cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
                source_filetype = 'python'
            },
        })
    else
        cb({
            type = 'executable',
            command = vim.fn.expand('$HOME/.virtualenvs/debugpy/bin/python'),
            args = { '-m', 'debugpy.adapter' },
            options = {
                source_filetype = 'python'
            },
        })
    end
end

dap.configurations.python = {
    {
        -- required 3 args for nvim-dap
        type = 'python'; -- type establishes link to adapter `dap.adapters.python`
        request = 'launch';
        name = 'Launch file';

        -- debugpy options
        program = "${file}"; -- launch the current file
        pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd ..'/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
            else
                return '/etc/profiles/per-user/dur/bin/python'
            end
        end;
    }
}


EOF

call luaeval('start_lsp(pyright_lsp_config)')
call luaeval('start_lsp(ruff_lsp_config)')


augroup python_format
    autocmd!
    autocmd BufWritePost <buffer> :silent lua vim.lsp.buf.format()
augroup end
