vim.g.mapleader = " "

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.completeopt = { "menu", "popup", "noinsert", "fuzzy" }

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true

-- Use ripgrep for :grep command
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Jump to quickfix results in another window automatically
vim.opt.switchbuf = "useopen,uselast"

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true

vim.opt.wildignore = { "__pycache__", "node_modules" }
vim.opt.listchars = { space = "_", tab = ">~" }

---------
-- LSP --
---------

require("lsp").setup()

-- LSP AUTO COMPLETE --
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
		vim.keymap.set("n", "gh", vim.lsp.buf.hover, { buffer = args.buf })
		-- vim.keymap.set("n", "gr", function()
		-- 	require("snacks").picker.lsp_references()
		-- end, { buffer = args.buf, desc = "LSP references" })
	end,
})

-- KEY MAP --
vim.keymap.set("i", "jk", "<esc>")

vim.opt.runtimepath:prepend(vim.env.TREEBOX_OUT or vim.fn.expand("~/.local/share/treebox"))

-- PLUGINS
vim.cmd("source " .. vim.fn.stdpath("config") .. "/plugme.vim")

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- vim.diagnostic.config({
-- 	virtual_text = false,
-- 	virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
-- 	underline = { severity = { min = vim.diagnostic.severity.ERROR } },
-- 	signs = { severity = { min = vim.diagnostic.severity.WARN } },
-- })

-- Zdiff (multi-buffer diff view)
require("zdiff").setup({
	diff = {
		show_line_numbers = "both",
	},
})
vim.keymap.set("n", "<leader>dz", function()
	require("zdiff").open()
end, { desc = "Open zdiff view" })
vim.keymap.set("n", "<leader>dm", function()
	require("zdiff").open("main")
end, { desc = "Open zdiff vs main" })
