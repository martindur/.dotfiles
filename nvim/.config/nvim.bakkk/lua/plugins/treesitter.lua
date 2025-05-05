return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
	  "html",
	  "css",
	  "javascript",
	  "typescript",
	  "python",
	  "c",
	  "json",
	  "yaml",
	  "toml",
	  "dockerfile",
	  "rust",
	  "go",
	  "elixir",
	  "gleam"
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
}

