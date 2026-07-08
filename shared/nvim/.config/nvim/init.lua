vim.g.mapleader = " "

vim.cmd('colorscheme habamax')

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1
vim.opt.expandtab = true
vim.opt.completeopt:append({ "fuzzy", "noinsert" })
vim.opt.switchbuf:append("useopen")

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Use ripgrep for :grep command
vim.opt.grepprg = "rg --vimgrep --smart-case"

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true

vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

---------
-- LSP --
---------
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})
vim.pack.add({
  { src = "https://github.com/martindur/zdiff.nvim" }
})

vim.keymap.set("n", "<leader>dz", function()
	require("zdiff").open()
end, { desc = "Open zdiff view" })
vim.keymap.set("n", "<leader>dm", function()
	require("zdiff").open("main")
end, { desc = "Open zdiff vs main" })

vim.lsp.enable({
  "clangd",
	"lua_ls",
	"ts_ls",
	"ty",
	"svelte",
	"tailwindcss",
	"sqlls",
	"zls",
	"rust_analyzer",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, event.buf, {
				autotrigger = true,
			})
		end
	end,
})

vim.keymap.set("i", "jk", "<esc>")

vim.opt.runtimepath:prepend(vim.env.TREEBOX_OUT or vim.fn.expand("~/.local/share/treebox"))

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

vim.treesitter.language.register("bash", "sh")
vim.treesitter.language.register("javascript", "javascriptreact")
vim.treesitter.language.register("tsx", "typescriptreact")

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = { "grep", "grepadd", "vimgrep", "vimgrepadd" },
  callback = function ()
    vim.cmd("cwindow")
  end,
})
