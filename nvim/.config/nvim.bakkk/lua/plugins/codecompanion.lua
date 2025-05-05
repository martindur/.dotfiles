return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          schema = {
            model = {
              default = "gpt-4",
            },
          },
        })
      end
    },
    strategies = {
      chat = { adapter = "anthropic" },
      inline = { adapter = "anthropic" }
    }
  },
  keys = {
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions" },
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat" }
  }
}
