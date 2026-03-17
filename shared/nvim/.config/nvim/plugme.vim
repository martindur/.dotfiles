call plug#begin()

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/snacks.nvim'
Plug 'stevearc/conform.nvim'
Plug 'stevearc/oil.nvim'
Plug 'saghen/blink.cmp', { 'tag': '*' }

Plug '~/projects/zdiff.nvim' " DEVELOPMENT

Plug 'folke/tokyonight.nvim'

call plug#end()
