---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  root_markers = { "tailwind.config.js", "tailwind.config.ts" },
  filetypes = { "html", "svelte", "elixir", "eelixir", "heex", "html-eex", "markdown", "css", "javascript", "typescript" }
}
