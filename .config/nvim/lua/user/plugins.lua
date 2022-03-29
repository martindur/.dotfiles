
local use = require('packer').use

require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager
    use { 'tpope/vim-commentary' }
    use {
        'windwp/nvim-autopairs',
        config = function ()
            require('nvim-autopairs').setup()
        end
    }
    use {
        'neovim/nvim-lspconfig',
        config = function ()
            require('user.plugins.lspconfig')
        end
    } -- Collection of configurations for the built-in LSP client
    use 'williamboman/nvim-lsp-installer' -- Simple interface for installing LSP servers
    use {
        "ellisonleao/gruvbox.nvim",
        config = function ()
            require('user.plugins.gruvbox')
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            { 'nvim-telescope/telescope-live-grep-raw.nvim' },
            { 'kyazdani42/nvim-web-devicons' }
        },
        config = function ()
            require('user.plugins.telescope')
        end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('user.plugins.treesitter')
        end
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            'onsails/lspkind-nvim',
        },
        config = function()
            require('user.plugins.cmp')
        end
    }
    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('user.plugins.bufferline')
        end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('user.plugins.lualine')
        end
    }
end)
