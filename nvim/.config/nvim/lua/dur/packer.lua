-- Packer

local packer = require('packer')

packer.startup(function(use)
    -- PACKER
    use('wbthomason/packer.nvim')

    -- COMMENTS
    use('tpope/vim-commentary')

    -- LSP
    use('williamboman/mason.nvim')
    use('williamboman/mason-lspconfig.nvim')
    use('neovim/nvim-lspconfig')

    -- CMP
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/nvim-cmp")
    use("tzachar/cmp-tabnine", { run = "./install.sh", requires = 'hrsh7th/nvim-cmp' })
    use("onsails/lspkind-nvim")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")

    -- TELESCOPE (FUZZY FINDER)
    use('nvim-lua/plenary.nvim')
    use('nvim-telescope/telescope.nvim')
    use('nvim-telescope/telescope-fzy-native.nvim')


    -- TREESITTER
    use('nvim-treesitter/nvim-treesitter')
end)
