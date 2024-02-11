return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "K", false } -- disable as hover key
      keys[#keys + 1] = { "<c-k>", false, mode = "i" } -- disable as signature key
      keys[#keys + 1] = { "gh", vim.lsp.buf.hover, { buffer = 0, desc = "symbol docs" } }
    end,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        tailwindcss = {
          init_options = {
            userLanguages = {
              elixir = "phoenix-heex",
              heex = "phoenix-heex",
            },
          },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("mix.exs", ".git")(fname) or util.path.dirname(fname)
          end,
        },
        marksman = {},
        -- html = {
        --   filetypes = { "heex" },
        -- },
        emmet_ls = {
          filetypes = { "heex", "html" },
        },
      },
    },
  },
}
