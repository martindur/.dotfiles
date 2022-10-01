local nnoremap = require("dur.utils").nnoremap

nnoremap("<leader>du", "<cmd>DBUIToggle<CR>")
nnoremap("<leader>df", "<cmd>DBUIFindBuffer<CR>")
nnoremap("<leader>dr", "<cmd>DBUIRenameBuffer<CR>")
nnoremap("<leader>dl", "<cmd>DBUILastQueryInfo<CR>")

vim.g.db_ui_save_location = '~/.config/db_ui'
