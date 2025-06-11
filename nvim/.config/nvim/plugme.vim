call plug#begin()

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'olimorris/codecompanion.nvim'
Plug 'ravitemer/codecompanion-history.nvim'
Plug 'Davidyz/VectorCode', { 'build': 'uv tool upgrade vectorcode' }
Plug 'ibhagwan/fzf-lua'
Plug 'stevearc/conform.nvim'
Plug 'saghen/blink.cmp', { 'tag': '*' }

" COLORSCHEME
Plug 'rebelot/kanagawa.nvim'

call plug#end()
