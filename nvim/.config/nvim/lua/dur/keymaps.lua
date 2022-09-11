local nnoremap = require("dur.utils").nnoremap

nnoremap(",", "<C-^>") -- Toggle active buffer between current/last buffer
nnoremap("<leader>pv", "<cmd>Ex<CR>") -- Open netrw
