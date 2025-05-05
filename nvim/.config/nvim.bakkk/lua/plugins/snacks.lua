return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    picker = { enabled = true },
    terminal = { enabled = true },
    lazygit = { enabled = true },
    explorer = { enabled = true }
  },
  keys = {
    -- Term
    { "<c-/>",	function() Snacks.terminal() end, desc = "Toggle Terminal" },
    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "lazygit" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "lazygit" },
    -- Fuzzy finders
    { "<leader>ff", function() Snacks.picker.files() end, desc = "File picker" },
    { "<leader>fh", function() Snacks.picker() end, desc = "List pickers" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffer picker" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "grep" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    -- LSP
    { "<leader>r", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
  }
}
