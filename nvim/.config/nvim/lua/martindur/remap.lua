local nnoremap = require("martindur.keymap").nnoremap

nnoremap("<leader>pv", "<cmd>Ex<CR>")


--nnoremap("<C-p>", ":Telescope")
nnoremap("<leader>f", function()
    require('telescope.builtin').find_files()
end)
