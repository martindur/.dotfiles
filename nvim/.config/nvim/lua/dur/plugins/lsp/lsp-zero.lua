return {
  "VonHeikemen/lsp-zero.nvim", branch = "v3.x",
  dependencies = {
    -- autocompletion
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    -- Language servers
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim"
  },
  config = function()
    local lsp_zero = require('lsp-zero')
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.on_attach(function(client, bufnr)
      lsp_zero.default_keymaps({buffer = bufnr})
    end)

    -- the default way to setup configuration with lsp-zero
    -- lsp_zero.setup_servers({'lua_ls', 'python'})

    -- Use this approach when language servers don't need configuration
    -- require('lspconfig').lua_ls.setup({})

    require('mason').setup({})
    require('mason-lspconfig').setup({
      -- Available LSP servers: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      ensure_installed = {
        'bashls',
        'cssls',
        'dockerls',
        'docker_compose_language_service',
        'elixirls',
        'erlangls',
        'gopls', -- Golang
        'graphql',
        'html',
        'jsonls',
        'tsserver',
        'lua_ls',
        'marksman', -- Markdown
        'nil_ls', -- Nix
        'pyright',
        'rust_analyzer',
        'sqlls',
        'svelte',
        'taplo',
        'tailwindcss',
        'yamlls'
      },
      handlers = {
        lsp_zero.default_setup,
      },
    })
  end
}
