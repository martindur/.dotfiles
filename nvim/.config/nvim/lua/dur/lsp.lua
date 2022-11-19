local utils = require('dur.utils')

-- LSP CONFIGURATION
local lspconfig = require('lspconfig')
-- local lsputils = require('lspconfig/util')
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true


-- local function config(_config)
-- 	return vim.tbl_deep_extend("force", {
-- 		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
-- 		on_attach = function()
-- 			nnoremap("gd", function() vim.lsp.buf.definition() end)
-- 			nnoremap("gh", function() vim.lsp.buf.hover() end)
-- 			nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
-- 			nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
-- 			nnoremap("[d", function() vim.diagnostic.goto_next() end)
-- 			nnoremap("]d", function() vim.diagnostic.goto_prev() end)
-- 			nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end)
-- 			nnoremap("<leader>vrr", function() vim.lsp.buf.references() end)
-- 			nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
-- 			-- inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
-- 		end,
-- 	}, _config or {})
-- end


local on_attach = function(_, bufnr)

    -- Local mapping function
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gh', vim.lsp.buf.hover, '[G]oto [H]over')

    nmap('gr', require('telescope.builtin').lsp_references)
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')


    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = 'Format current buffer with LSP' })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("mason").setup()

local servers = { 'pyright', 'html', 'tsserver', 'svelte', 'tailwindcss' }

require("mason-lspconfig").setup({
    ensure_installed = servers,
})


for _, lsp in ipairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end


-- PYTHON LSP CONFIG
-- lspconfig.pyright.setup(config{
--     before_init = function(_, _config)
--         --_config.settings.python.pythonPath = lsputils.path.join(_config.root_dir, '.venv/bin/python')
--         -- Utility function not working properly. Might want to fix it, so we are not always reliant
--         -- on a venv
--         _config.settings.python.pythonPath = utils.get_python_path(_config.root_dir)
--     end
-- })

-- LUA LSP CONFIG
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
            temeletry = { enable = false },
        },
    },
}


-- lspconfig.sumneko_lua.setup(config({
-- 	-- cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
-- 	settings = {
-- 		Lua = {
-- 			runtime = {
-- 				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
-- 				version = "LuaJIT",
-- 				-- Setup your lua path
-- 				path = vim.split(package.path, ";"),
-- 			},
-- 			diagnostics = {
-- 				-- Get the language server to recognize the `vim` global
-- 				globals = { "vim" },
-- 			},
-- 			workspace = {
-- 				-- Make the server aware of Neovim runtime files
-- 				library = {
-- 					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
-- 					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
-- 				},
-- 			},
-- 		},
-- 	},
-- }))

-- OTHER LSP CONFIGs

-- lspconfig.svelte.setup{}
-- lspconfig.html.setup{}
-- lspconfig.gopls.setup{}
-- lspconfig.jsonls.setup{}


-- COMPLETION

local cmp = require("cmp")

-- Autopairs with completion
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

local luasnip = require('luasnip')
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
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        -- ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<Return>'] = cmp.mapping.confirm({ select = true }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif utils.has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {'i', 's'}),
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
