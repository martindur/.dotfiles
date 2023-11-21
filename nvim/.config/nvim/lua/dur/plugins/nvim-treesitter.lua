return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  config = function ()
    local configs = require('nvim-treesitter.configs')

    configs.setup({
      ensure_installed = { "lua", "python", "vim", "html", "css", "elixir", "heex", "javascript", "typescript", "go", "rust", "svelte" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
