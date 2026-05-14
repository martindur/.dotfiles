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
		vim.keymap.set("n", "gr", function()
			require("snacks").picker.lsp_references()
		end, { buffer = args.buf, desc = "LSP references" })
	end,
})

-- KEY MAP --
vim.keymap.set({ "n", "v" }, "J", "10j")
vim.keymap.set({ "n", "v" }, "K", "10k")
vim.keymap.set("i", "jk", "<esc>")

-- File finding --
vim.keymap.set({ "n" }, "<leader>g", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })

vim.keymap.set({ "n" }, "<leader>e", "<cmd>Oil --float<cr>")

-- Exit terminal mode
vim.keymap.set({ "t" }, "<c-x>", "<c-\\><c-n>")

-- PLUGINS
vim.cmd("source " .. vim.fn.stdpath("config") .. "/plugme.vim")

require("oil").setup({
	keymaps = {
		["q"] = { "actions.close", mode = "n" },
	},
})

require("tokyonight").setup({
	transparent = true,
})
vim.cmd.colorscheme("tokyonight")

local snacks = require("snacks")
vim.keymap.set({ "n" }, "<leader>f", function()
	snacks.picker.files()
end, { desc = "find project files" })
vim.keymap.set({ "n" }, "<leader>b", function()
	snacks.picker.buffers()
end, { desc = "find files from current buffers" })
vim.keymap.set({ "n" }, "<leader>t", function()
	snacks.picker.grep()
end, { desc = "live grep" })
vim.keymap.set({ "n" }, "<leader>w", function()
	snacks.picker.grep_word()
end, { desc = "grep word under cursor" })
vim.keymap.set({ "n" }, ",", function()
	snacks.picker.resume()
end, { desc = "re-run last query" })

-- Agents picker: find files in .agents/ subdirectory, ignoring gitignore
vim.keymap.set({ "n" }, "<leader>a", function()
	snacks.picker.files({
		cwd = vim.fn.getcwd() .. "/.agents",
		hidden = true,
		ignored = true, -- include gitignored files
	})
end, { desc = "find files in .agents/" })

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
	underline = { severity = { min = vim.diagnostic.severity.ERROR } },
	signs = { severity = { min = vim.diagnostic.severity.WARN } },
})

-- Zdiff (multi-buffer diff view)
require("zdiff").setup({
	diff = {
		show_line_numbers = "both",
	},
	-- engine = "diffbox",
	-- diffbox_cmd = {
	--   vim.fn.expand("~/projects/diffbox/target/debug/diffbox"),
	-- }
})
vim.keymap.set("n", "<leader>dz", function()
	require("zdiff").open()
end, { desc = "Open zdiff view" })
vim.keymap.set("n", "<leader>dm", function()
	require("zdiff").open("main")
end, { desc = "Open zdiff vs main" })

-- Repo-local notes
require("repo_notes").setup()
vim.keymap.set("n", "<leader>na", "<cmd>NoteAdd<cr>", { desc = "add repo note" })
vim.keymap.set("n", "<leader>nd", "<cmd>NoteDone<cr>", { desc = "remove repo note on current line" })
vim.keymap.set("n", "<leader>nl", "<cmd>NoteList<cr>", { desc = "list repo notes" })
vim.keymap.set("n", "<leader>nr", "<cmd>NoteReload<cr>", { desc = "reload repo notes" })

-- CHECKS --

vim.api.nvim_create_user_command("RuffCheck", function()
	vim.cmd("cexpr system('uv run ruff check --output-format=concise --select=F .')")
	vim.cmd("copen")
end, {})

-- CONFORM (FORMATTING) --
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		astro = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- SNACKS --
require("snacks").setup({
	lazygit = { enabled = true },
	gh = { enabled = true },
	picker = {
		enabled = true,
		layout = {
			layout = {
				width = 0.95,
				height = 0.9,
			},
		},
		sources = {
			files = {
				hidden = true,
			},
		},
	},
})

vim.keymap.set("n", "<leader>pr", function()
	Snacks.picker.gh_pr()
end)

-- AUTOCOMPLETION --
require("blink.cmp").setup()
