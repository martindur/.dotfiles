local nnoremap = require('martindur.keymap').nnoremap


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
