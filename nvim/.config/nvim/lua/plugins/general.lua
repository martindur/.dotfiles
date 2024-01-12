return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", "<cmd>Neotree<cr>", { desc = "explorer focus" } },
      { "<leader>o", "<cmd>Neotree toggle<cr>", { desc = "explorer toggle" } },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
  },
}
