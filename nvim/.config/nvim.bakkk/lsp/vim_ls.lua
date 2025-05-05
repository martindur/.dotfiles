---@type vim.lsp.Config
return {
  cmd = { "vim-language-server", "--stdio" },
  root_markers = { "runtime", "nvim", ".git", "autoload", "plugin" },
  filetypes = { "vim" },
}
