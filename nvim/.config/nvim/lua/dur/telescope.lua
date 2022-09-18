
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

nnoremap("<leader>b", function()
    telescope.buffers()
end)

nnoremap("<leader>F", function()
    telescope.find_files({hidden=true})
end)

nnoremap("<leader>vrc", function()
    search_dotfiles()
end)
