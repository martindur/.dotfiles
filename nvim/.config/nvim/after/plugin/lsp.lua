local lsp_util = require('lspconfig/util')
local utils = require('martindur.keymap')
local nnoremap = utils.nnoremap

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- LSP INSTALLERS
local lsp_installer = require("nvim-lsp-installer")

-- Automatically installs LSPs in servers list
local servers = { 'pyright', 'sumneko_lua', 'html', 'sqlls', 'eslint'}
for _, lsp in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(lsp)
    if server_is_found and not server:is_installed() then
        print("Installing " .. lsp)
        server:install()
    end
end

-- Setup nvim-cmp (Completion)
local cmp = require("cmp")
local source_mapping = {
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    cmp_tabnine = "[TN]",
    path = "[Path]"
}
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),

    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]
            local menu = source_mapping[entry.source.name]
            if entry.source.name == "cmp_tabnine" then
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                    menu = entry.completion_item.data.detail .. " " .. menu
                end
                vim_item.kind = ""
            end
            vim_item.menu = menu
            return vim_item
        end,
    },

    sources = {
        { name = "cmp_tabnine" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
    },
})

local tabnine = require("cmp_tabnine.config")
tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = "..",
})

-- Mappings.

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


-- Handles any extra config required for LSPs
lsp_installer.on_server_ready(function(server)
    local server_opts = config()

    if server.name == 'pyright' then
      before_init = function(_, _config)
        local p
        if vim.env.VIRTUAL_ENV then
          p = lsp_util.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
        else
          p = utils.find_cmd('python', 'venv/bin', _config.root_dir)
        end
        _config.settings.python.pythonPath = p
        --config.settings.python.venvPath = config.root_dir
        --config.settings.python.venv = 'venv'
    -- TODO
    -- elseif server.name == 'sumneko_lua' then
    --   config = config({
        
    --   })
    end
    server_opts['before_init'] = before_init
end
    server:setup(server_opts)
end)
