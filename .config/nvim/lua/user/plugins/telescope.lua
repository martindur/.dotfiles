local telescope = require('telescope')

local keymap = require('lib.utils').keymap


telescope.load_extension('fzf')

keymap('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
keymap('n', '<leader>b', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
keymap('n', '<leader>h', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
keymap('n', '<leader>r', [[<cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<CR>]])
