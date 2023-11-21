return {
  'nvim-telescope/telescope.nvim', tag = '0.1.4',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { 'nvim-telescope/telescope-live-grep-args.nvim', version = "^1.0.0" }
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local lg_actions = require('telescope-live-grep-args.actions')

    telescope.setup({
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = " -t" }),
              ["<C-i>"] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = " --iglob " }),
            },
          },
        }

      }
    })

    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")

    -- General keymaps
    vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
    --vim.keymap.set('n', '<leader>s', builtin.live_grep, { desc = 'Live grep files' })
    vim.keymap.set('n', '<leader>s', telescope.extensions.live_grep_args.live_grep_args, { desc = 'Live grep with args' })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find in buffers' })

  end
}
