call plug#begin()

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-tree/nvim-web-devicons'
"Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'folke/snacks.nvim'
" vim-plug
Plug 'ibhagwan/fzf-lua'
Plug 'stevearc/conform.nvim'
Plug 'stevearc/oil.nvim'
Plug 'saghen/blink.cmp', { 'tag': '*' }
Plug 'folke/trouble.nvim'

" DB
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

" COLORSCHEME
"Plug 'rebelot/kanagawa.nvim'
"Plug 'rose-pine/neovim'
Plug 'folke/tokyonight.nvim'

call plug#end()
