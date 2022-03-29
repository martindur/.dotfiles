local keymap = require 'lib.utils'.keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('n', '<leader>ve', ':edit ~/.config/nvim/init.lua<CR>')
keymap('n', '<leader>vk', ':edit ~/.config/nvim/lua/user/keymaps.lua<CR>')
keymap('n', '<leader>k', ':nohlsearch<CR>')

-- allow gf to open non-existent files
keymap('', 'gf', ':edit <cfile><CR>')
