-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')
  use ('tpope/vim-commentary')

  -- Telescope (Fuzzy finder)
  use('nvim-lua/plenary.nvim')
  use('nvim-telescope/telescope.nvim')
  use('nvim-telescope/telescope-fzy-native.nvim')

  -- LSP and Completion
  use('neovim/nvim-lspconfig')
  use('williamboman/nvim-lsp-installer')
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/nvim-cmp")
  use("tzachar/cmp-tabnine", { run = "./install.sh", requires = 'hrsh7th/nvim-cmp' })
  use("onsails/lspkind-nvim")
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")

  -- Git
  use('TimUntersberger/neogit')

  -- Color schemes
  use('folke/tokyonight.nvim')
  use('gruvbox-community/gruvbox')

  -- use {
  --   'nvim-telescope/telescope.nvim',
  --   requires = {
  --       { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  --       { 'nvim-telescope/telescope-live-grep-raw.nvim' }
  --   }
  -- }

  use('theprimeagen/harpoon')

  use('vimwiki/vimwiki')

  end)
