require('telescope').load_extension('fzf')
require('telescope').setup({
  pickers = {
    find_files = {
      theme = "ivy"
    }
  },
  extensions = {
    fzf = {}
  }
})

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "lua", "vim", "vimdoc", "javascript", "typescript", "svelte", "html",
    "css", "python", "markdown", "sql"
  },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true }
})

-- LSP

local lspconfig = require('lspconfig')
local cmp = require('blink.cmp')
local capa = cmp.get_lsp_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local builtin = require('telescope.builtin')

    -- format on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end
    })

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { buffer = bufnr })
    vim.keymap.set('n', '<leader>r', builtin.lsp_references, { buffer = bufnr })
  end
})

lspconfig.lua_ls.setup({
  capabilities = capa,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        globals = { "vim" }
      },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false
      },
      telemetry = {
        enable = false
      }
    }
  }
})

lspconfig.vimls.setup({ capabilities = capa })
lspconfig.tailwindcss.setup({ capabilities = capa })
lspconfig.sqlls.setup({ capabilities = capa })

lspconfig.ts_ls.setup {
  filetypes = {
    "javascript",
    "typescript",
    "svelte"
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  capabilities = capa
}

cmp.setup()
require('multigrep').setup()
