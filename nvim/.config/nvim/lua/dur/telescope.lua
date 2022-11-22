
-- CONFIG

require("telescope").setup({
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
})

require('telescope').load_extension('fzy_native')


local search_dotfiles = function()
    require("telescope/builtin").find_files({
        prompt_title = "< VimRC >",
        cwd = vim.env.DOTFILES,
        hidden = true,
    })
end




-- KEYMAP

local nnoremap = require('dur.utils').nnoremap


local telescope = require('telescope.builtin')

--telescope.load_extension('fzf')

nnoremap("<leader>f", function()
    telescope.find_files()
end)

vim.keymap.set('n', '<leader>b', telescope.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>h', telescope.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', 'ff', telescope.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>s', telescope.live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

nnoremap("<leader>F", function()
    telescope.find_files({hidden=true})
end)

nnoremap("<leader>vrc", function()
    search_dotfiles()
end)
