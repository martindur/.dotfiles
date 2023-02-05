local nnoremap = require("dur.utils").nnoremap

nnoremap(",", "<C-^>") -- Toggle active buffer between current/last buffer
nnoremap("<leader>pv", "<cmd>Ex<CR>") -- Open netrw

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
