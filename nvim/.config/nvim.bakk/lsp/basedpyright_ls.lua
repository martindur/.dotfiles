---@type vim.lsp.Config
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  root_markers = { "pyproject.toml", "requirements.txt", ".git" },
  filetypes = { "python" },
}
