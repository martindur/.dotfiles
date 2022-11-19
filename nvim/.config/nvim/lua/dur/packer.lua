-- Packer

local packer = require('packer')

packer.startup(function(use)
    -- PACKER
    use('wbthomason/packer.nvim')

    -- COMMENTS
    use{
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use('tpope/vim-sleuth') -- Detect tabstop and shiftwidth automatically
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

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
    use('nvim-treesitter/nvim-treesitter-context')
    use('nvim-treesitter/nvim-treesitter-textobjects')

    -- COLORTHEME
    use('navarasu/onedark.nvim')

    -- LUALINE
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- INDENT GUIDE
    use('lukas-reineke/indent-blankline.nvim')

    -- WIKI
    use('vimwiki/vimwiki')

    -- DATABASES
    use('tpope/vim-dadbod')
    use('kristijanhusak/vim-dadbod-ui')

    end)
