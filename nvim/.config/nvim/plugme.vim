call plug#begin()

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'olimorris/codecompanion.nvim'
Plug 'ravitemer/codecompanion-history.nvim'
" these 'build' commands might be lying - check if actually supported in
" vim-plug
Plug 'ravitemer/mcphub.nvim', { 'build': 'bun install -g mcp-hub@latest' }
Plug 'Davidyz/VectorCode', { 'build': 'uv tool upgrade vectorcode' }
Plug 'ibhagwan/fzf-lua'
Plug 'stevearc/conform.nvim'
Plug 'saghen/blink.cmp', { 'tag': '*' }

" DB
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

" COLORSCHEME
"Plug 'rebelot/kanagawa.nvim'
"Plug 'rose-pine/neovim'
Plug 'folke/tokyonight.nvim'

call plug#end()
