vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf)

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = args.buf })
  end
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('vim_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('sql_ls')
vim.lsp.enable('tailwindcss_ls')
vim.lsp.enable('svelte_ls')
vim.lsp.enable('basedpyright_ls')
vim.lsp.enable('gleam_ls')
