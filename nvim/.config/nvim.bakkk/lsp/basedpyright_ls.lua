---@type vim.lsp.Config
return {
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
  }
}
