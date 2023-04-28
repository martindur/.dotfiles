-- CONFIG

require("telescope").setup({
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
		media_files = {
			filetypes = { "png", "webp", "jpg", "jpeg", "webm" },
			find_cmd = "rg", -- find command (defaults to `fd`)
		},
	},
})

require("telescope").load_extension("fzy_native")
require("telescope").load_extension("media_files")
require("telescope").load_extension("file_browser")

local search_dotfiles = function()
	require("telescope/builtin").find_files({
		prompt_title = "< VimRC >",
		cwd = vim.env.DOTFILES,
		hidden = true,
	})
end

local search_mediafiles = function()
	require("telescope").extensions.media_files.media_files()
end

-- KEYMAP

local telescope = require("telescope.builtin")

--telescope.load_extension('fzf')

vim.keymap.set("n", "<leader>f", function()
	telescope.find_files()
end)

vim.keymap.set("n", "<leader>b", telescope.buffers, { desc = "[ ] Find existing buffers" })

vim.keymap.set("n", "<leader>h", telescope.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "ff", telescope.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>s", telescope.live_grep, { desc = "[S]earch by [G]rep" })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set("n", "<leader>F", function()
	telescope.find_files({ hidden = true })
end)

vim.keymap.set("n", "<leader>vrc", function()
	search_dotfiles()
end)

vim.keymap.set("n", "<leader>m", function()
	search_mediafiles()
end)

vim.keymap.set("n", "<leader>pf", ":Telescope file_browser<CR>")
