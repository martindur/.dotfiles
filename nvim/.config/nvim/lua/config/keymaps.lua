-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local nnoremap = function(lhs, rhs, opts)
  vim.keymap.set("n", lhs, rhs, opts)
end

local vnoremap = function(lhs, rhs, opts)
  vim.keymap.set("v", lhs, rhs, opts)
end

local inoremap = function(lhs, rhs, opts)
  vim.keymap.set("i", lhs, rhs, opts)
end

local del = vim.keymap.del

inoremap("jk", "<esc>", { desc = "esc from insert mode with jk" })

-- a convenient way to jump right of "pairs" in insert mode
inoremap("<tab>", function()
  return vim.fn.search("\\%#[]>)}'\"]", "n") ~= 0 and "<right>" or "<tab>"
end, { expr = true })

-- I just need a simple and fast write (I don't use windows, my terminal handles that)
del("n", "<leader>wd")
del("n", "<leader>ww")
del("n", "<leader>w|")
del("n", "<leader>w-")

nnoremap("<leader>w", ":w<cr>", { desc = "write buffer", silent = true })

nnoremap("J", "10j", { desc = "Fast vertical navigation down", silent = true })
nnoremap("K", "10k", { desc = "Fast vertical navigation up", silent = true })

vnoremap("J", "10j", { desc = "Fast vertical navigation down", silent = true })
vnoremap("K", "10k", { desc = "Fast vertical navigation up", silent = true })

-- Terminal keys
nnoremap("<leader>tl", ":vsplit | vertical resize 80 | terminal<cr>", { desc = "Open a terminal in a split to the right", silent = true})
nnoremap("<leader>tj", ":split | terminal<cr>", { desc = "Open a terminal in a split to the bottom", silent = true})

nnoremap("<C-Up>", ":resize +4<cr>", { silent = true })
nnoremap("<C-Down>", ":resize -4<cr>", { silent = true })
nnoremap("<C-Left>", ":vertical resize -4<cr>", { silent = true })
nnoremap("<C-Right>", ":vertical resize +4<cr>", { silent = true })
