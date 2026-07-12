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
vim.opt.path:append({ "**", "**/.[^.]*/**" })
vim.opt.wildignore:append({
	"**/.git/**",
	"**/node_modules/**",
	"**/dist/**",
	"**/target/**",
})

---------
-- LSP --
---------
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})
-- vim.pack.add({
--   { src = "https://github.com/martindur/zdiff.nvim" }
-- })
-- DEVELOPMENT:
vim.opt.runtimepath:prepend(vim.fn.expand("~/projects/zdiff.nvim"))

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
vim.keymap.set("t", "<C-\\>", [[<C-\><C-n>]], {
  desc = "Exit terminal mode",
})

vim.keymap.set("n", "<leader>g", "<cmd>term lazygit<cr>", { desc = "launch lazygit in a terminal" })

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


vim.api.nvim_create_autocmd("FileType", {
  pattern = "zdiff",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    vim.keymap.set("n", "<CR>", "<cmd>ZdiffOpen<cr>", opts)
    vim.keymap.set("n", "<Tab>", "<cmd>ZdiffToggle<cr>", opts)
    vim.keymap.set("n", "R", "<cmd>ZdiffRefresh<cr>", opts)
    vim.keymap.set("n", "q", "<cmd>bdelete<cr>", opts)

    vim.keymap.set("n", "m", function()
      if vim.b.zdiff.base == "" then
        vim.cmd("Zdiff main")
      else
        vim.cmd("Zdiff")
      end
    end, opts)
  end,
})
