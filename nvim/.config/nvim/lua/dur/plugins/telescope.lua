return {
  'nvim-telescope/telescope.nvim', tag = '0.1.4',
  dependencies = { 'nvim-lua/plenary.nvim', { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    telescope.load_extension("fzf")

    vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>s', builtin.live_grep, { desc = 'Live grep files' })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find in buffers' })
  end
}
