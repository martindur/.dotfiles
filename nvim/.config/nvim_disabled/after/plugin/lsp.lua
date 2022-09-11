local lspconfig = require('lspconfig')
local lsp_util = require('lspconfig/util')
local utils = require('martindur.utils')
local keymap = require('martindur.keymap')
local nnoremap = keymap.nnoremap

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


local function config(_config)
	return vim.tbl_deep_extend("force", {
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		on_attach = function()
			nnoremap("gd", function() vim.lsp.buf.definition() end)
			nnoremap("gh", function() vim.lsp.buf.hover() end)
			nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
			nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
			nnoremap("[d", function() vim.diagnostic.goto_next() end)
			nnoremap("]d", function() vim.diagnostic.goto_prev() end)
			nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end)
			nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
			nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
			-- inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
		end,
	}, _config or {})
end

local function lsp_highlight_selection(client)
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
            augroup lsp_selection_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            ]],
            false
        )
    end
end




-- LSP CONFIGURATION

local diagnostic_config = {
    -- disable virtual text
    -- virtual_text = false,
    -- show signs
    -- signs = {active = signs} -- Need a dict of signs
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}

vim.diagnostic.config(diagnostic_config)

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "sumneko_lua",
        -- "pyright",
        "pylsp",
        -- "sourcery",
        --"jedi_language_server",
        "cssls",
        "html",
        "sqlls",
        "tsserver",
        "dockerls" }
})



-- lspconfig.pyright.setup(config{
--     -- settings = {
--     --     python = {
--     --         pythonPath = utils.get_python_venv(lspconfig.util.find_git_ancestor()),
--     --         venvPath = lspconfig.util.find_git_ancestor(),
--     --         venv = "venv"
--     --     }
--     -- }
--     before_init = function(_, _config)
--         _config.settings.python.pythonPath = utils.get_python_path(_config.root_dir)
--         -- _config.settings.python.venvPath = _config.root_dir
--         -- _config.settings.python.venv = 'venv'
--     end
--     -- on_init = function(client)
--     --     client.config.settings.python.pythonPath = utils.get_python_path(client.config.root_dir)
--     --     config.settings.python.venvPath = config.root_dir
--     --     config.settings.python.venv = 'venv'
--     -- end
-- })

-- lspconfig.jedi_language_server.setup(config{})
lspconfig.pylsp.setup(config{
    before_init = function(_, _config)
        config.settings.pylsp.plugins.jedi.environment = utils.get_python_path(_config.root_dir)
    end
})
--lspconfig.sourcery.setup(config{})

lspconfig.sumneko_lua.setup(config({
	-- cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
		},
	},
}))

-- Handles any extra config required for LSPs
--lsp_installer.on_server_ready(function(server)
--    local server_opts = config()

--    if server.name == 'pyright' then
--      before_init = function(_, _config)
--        local p
--        if vim.env.VIRTUAL_ENV then
--          p = lsp_util.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
--        else
--          p = utils.find_cmd('python', 'venv/bin', _config.root_dir)
--        end
--        _config.settings.python.pythonPath = p
--        --config.settings.python.venvPath = config.root_dir
--        --config.settings.python.venv = 'venv'
--    -- TODO
--    -- elseif server.name == 'sumneko_lua' then
--    --   config = config({
        
--    --   })
--    end
--    server_opts['before_init'] = before_init
--end
--    server:setup(server_opts)
--end)
