local nnoremap = require('martindur.keymap').nnoremap


local telescope = require('telescope.builtin')

nnoremap("<leader>f", function()
    telescope.find_files()
end)

nnoremap("<leader>F", function()
    telescope.find_files({hidden=true})
end)
