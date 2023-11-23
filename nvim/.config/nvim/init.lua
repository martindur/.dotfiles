--require("dur.core") -- configs
--require("dur.lazy") -- plugins

--vim.cmd [[colorscheme tokyonight]]


-- Testing out "raw" single file

vim.cmd.colorscheme("habamax")
vim.cmd('syntax enable')

vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.wrap = true

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  desc = "Briefly highlight yanked text"
})


--
--------- LSP ---------
--

-- Elixir LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = "elixir", -- nvim has filetype detection, and understands .ex files are "elixir" filetypes
  callback = function(args)
    vim.lsp.start({
      name = 'elixir-ls',
      cmd = {'elixir-ls'},
      root_dir = vim.fs.dirname(vim.fs.find({'mix.exs'}, {upward = true})[1])
    })
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
  end,
})
