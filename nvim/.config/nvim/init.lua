--require("dur.core") -- configs
--require("dur.lazy") -- plugins

--vim.cmd [[colorscheme tokyonight]]


-- Testing out "raw" single file

vim.cmd.colorscheme("habamax")
vim.cmd('syntax enable')


vim.g.mapleader = ' '
vim.keymap.set({"n", "x", "v"}, "J", "10j", { silent = true })
vim.keymap.set({"n", "x", "v"}, "K", "10k", { silent = true })


vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.wrap = true

vim.opt.clipboard:append("unnamedplus")

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  desc = "Briefly highlight yanked text"
})


--
--------- LSP ---------
--

-- Elixir LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = "elixir", -- nvim has filetype detection, and understands .ex files are "elixir" filetypes
  callback = function(args)
    vim.lsp.start({
      name = 'elixir-ls',
      cmd = {'elixir-ls'},
      root_dir = vim.fs.dirname(vim.fs.find({'mix.exs'}, {upward = true})[1])
    })
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = args.buf })
  end,
})


--
-------- PLUGINS --------
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- telescope (workspace navigation with fuzzy finding)
local telescope = {
  'nvim-telescope/telescope.nvim', tag = '0.1.4',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-live-grep-args.nvim', version = '^1.0.0' }
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
    vim.keymap.set('n', '<leader>s', telescope.extensions.live_grep_args.live_grep_args, { desc = 'Live grep with args' })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find in buffers' })
  end
}

-- Treesitter (syntax highlighting and "understanding" of file structure)
local treesitter = {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function ()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "python",
        "html",
        "css",
        "elixir",
        "eex",
        "heex",
        "javascript",
        "typescript",
        "go",
        "rust",
        "svelte"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true }
    })
  end
}

-- convenient way to disable/enable specific plugins
local plugins = { 
  telescope,
  treesitter
}

local config = {} -- just to be verbose

require('lazy').setup(plugins, config)
