---@type vim.lsp.Config
return {
  cmd = { "svelteserver", "--stdio" },
  root_markers = { "package.json", ".git" },
  filetypes = { "svelte" }
}
