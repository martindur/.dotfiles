local lsp = require("lsp-zero")
local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

-- lsp.preset({ name = "recommended" })

lsp.preset({
	name = "minimal",
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = true,
})

-- No fuss setup!
--lsp.setup()

--[[lsp.ensure_installed({
	'tsserver',
	'eslint',
	'sumneko_lua',
	'rust_analyzer',
	'pyright',
})]]
lsp.setup()

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettierd.with({
			filetypes = {
				"javascript",
				"typescript",
				"css",
				"scss",
				"json",
				"markdown",
				"html",
				"vue",
				"svelte",
			},
		}),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.sqlformat,
		null_ls.builtins.formatting.djhtml,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
