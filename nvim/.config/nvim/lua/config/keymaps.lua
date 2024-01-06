-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local nnoremap = function(lhs, rhs, opts)
  vim.keymap.set("n", lhs, rhs, opts)
end

local inoremap = function(lhs, rhs, opts)
  vim.keymap.set("i", lhs, rhs, opts)
end

local del = vim.keymap.del

inoremap("jk", "<esc>", { desc = "esc from insert mode with jk" })

-- I just need a simple and fast write (I don't use windows, my terminal handles that)
del("n", "<leader>wd")
del("n", "<leader>ww")
del("n", "<leader>w|")
del("n", "<leader>w-")

nnoremap("<leader>w", ":w<cr>", { desc = "write buffer" })

nnoremap("J", "10j", { desc = "Fast vertical navigation down" })
nnoremap("K", "10k", { desc = "Fast vertical navigation up" })
