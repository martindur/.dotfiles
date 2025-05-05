-- :h lsp-config

-- auto completion
-- local triggers = { "." }
-- vim.api.nvim_create_autocmd("InsertCharPre", {
--   buffer = vim.api.nvim_get_current_buf(),
--   callback = function()
--     if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
--       return
--     end
--     local char = vim.v.char
--     if vim.list_contains(triggers, char) then
--       local key = vim.keycode("<C-x><C-o>")
--       vim.api.nvim_feedkeys(key, "m", false)
--     end
--   end
-- })

-- lsp setup
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf)
    local tsb = require('telescope.builtin')

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set('n', '<leader>r', tsb.lsp_references, { buffer = args.buf })

    if client:supports_method('textDocument/formatting') then
      -- Format the current buffer on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
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
