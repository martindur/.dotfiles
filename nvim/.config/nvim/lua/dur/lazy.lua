local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
  { import = "dur.plugins" },
  { import = "dur.plugins.lsp" }
}

config = {
  install = {
    colorscheme = { "tokyonight" },
  },
}

require("lazy").setup(plugins, config)
