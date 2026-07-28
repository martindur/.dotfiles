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

vim.keymap.set("n", "<leader>g", "<cmd>tabnew | term lazygit<cr>", { desc = "launch lazygit in a new tab" })
vim.keymap.set("n", "<leader>t", ":tabnew | term ", { desc = "launch any process in a new tab" })
vim.keymap.set("n", "<leader>v", ":vert term ", { desc = "launch any process in vertical split" })

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
    vim.keymap.set("n", "q", "<cmd>b# | bd#<cr>", opts)

    vim.keymap.set("n", "m", function()
      if vim.b.zdiff.base == "" then
        vim.cmd("Zdiff main")
      else
        vim.cmd("Zdiff")
      end
    end, opts)
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd('startinsert')
  end
})

local function pick_file(command)
  local source_window = vim.api.nvim_get_current_win()
  local cwd = vim.fn.getcwd()
  local output = vim.fn.tempname()

  vim.cmd.tabnew()

  local picker_tab = vim.api.nvim_get_current_tabpage()
  local picker_buffer = vim.api.nvim_get_current_buf()
  local shell_command = command .. " | fzf > " .. vim.fn.shellescape(output)

  vim.fn.jobstart({ "sh", "-c", shell_command }, {
    term = true,
    cwd = cwd,

    on_exit = function()
      vim.schedule(function()
        local selection = vim.fn.readfile(output)[1]
        vim.fn.delete(output)

        if vim.api.nvim_tabpage_is_valid(picker_tab) then
          vim.api.nvim_set_current_tabpage(picker_tab)
          vim.cmd.tabclose()
        end

        if vim.api.nvim_buf_is_valid(picker_buffer) then
          vim.api.nvim_buf_delete(picker_buffer, { force = true })
        end

        if vim.api.nvim_win_is_valid(source_window) then
          vim.api.nvim_set_current_win(source_window)
          if selection then
            vim.cmd.edit(vim.fn.fnameescape(vim.fs.joinpath(cwd, selection)))
          end
        end
      end)
    end
  })
end

vim.keymap.set("n", "<leader>f", function()
  pick_file("rg --files")
end, { desc = "find files" })

vim.keymap.set("n", "<leader>F", function()
  pick_file("rg --files --hidden")
end, { desc = "find files" })

vim.api.nvim_create_user_command("CodexReview", function(options)
  require("codex_review").review(options.args)
end, {
  nargs = 1,
  complete = function(argument)
    return require("codex_review").complete(argument)
  end,
  desc = "Review with a Codex lens or review a GitHub pull request",
})

vim.api.nvim_create_user_command("CodexWork", function(options)
  require("codex_work").start(options.args)
end, {
  nargs = 1,
  desc = "Plan work for a Linear issue in a new Git worktree",
})
