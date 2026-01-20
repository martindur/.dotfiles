local M = {}

-- LUA --
vim.lsp.config.lua_ls = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  telemetry = { enabled = false },
  formatters = {
    ignoreComments = false,
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT"
      },
      signatureHelp = { enabled = true }
    }
  }
}

-- TS/JS --
vim.lsp.config.ts_ls = {
  cmd = { 'typescript-language-server', "--stdio" },
  filetypes = { 'javascript', "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "svelte" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  init_options = {
    hostInfo = "neovim"
  }
}

-- PYTHON --
vim.lsp.config.pyright = {
  cmd = { "basedpyright-langserver", "--stdio" },
  root_markers = { "pyproject.toml", "requirements.txt", ".git" },
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace"
      }
    }
  },
  flags = {
    debounce_text_changes = 150,
    exit_timeout = 300
  }
}

-- ASTRO --
vim.lsp.config.astro_ls = {
  cmd = { 'astro-ls', '--stdio' },
  filetypes = { 'astro' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  init_options = {
    typescript = {
      tsdk = vim.fn.getcwd() .. '/node_modules/typescript/lib'
    }
  },
}

-- SVELTE --
vim.lsp.config.svelte_ls = {
  cmd = { "svelteserver", "--stdio" },
  root_markers = { "package.json", ".git" },
  filetypes = { "svelte" }
}

-- TAILWINDCSS --
vim.lsp.config.tailwindcss_ls = {
  cmd = { "tailwindcss-language-server", "--stdio" },
  root_markers = { "tailwind.config.js", "tailwind.config.ts" },
  filetypes = { "html", "svelte", "elixir", "eelixir", "heex", "html-eex", "markdown", "css", "javascript", "typescript", "astro" }
}

-- SQL --
vim.lsp.config.sql_ls = {
  cmd = { "sql-language-server", "up", "--method", "stdio" },
  root_markers = { ".git" },
  filetypes = { "sql" },
}

-- JSON --
vim.lsp.config.json_ls = {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc', 'json5' },
  root_markers = { '.git' }
}

-- ZIG --
vim.lsp.config.zig_ls = {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { '.git' }
}

function M.setup()
  vim.lsp.enable("lua_ls")
  vim.lsp.enable("ts_ls")
  vim.lsp.enable("pyright")
  vim.lsp.enable("astro_ls")
  vim.lsp.enable("svelte_ls")
  vim.lsp.enable("tailwindcss_ls")
  vim.lsp.enable("sql_ls")
  vim.lsp.enable("json_ls")
  vim.lsp.enable("zig_ls")
end

return M
