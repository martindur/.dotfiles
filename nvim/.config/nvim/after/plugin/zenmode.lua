require("zen-mode").setup {
    window = {
        width = 120,
        options = {
            number = true,
            relativenumber = true,
        }
    },
}

vim.keymap.set("n", "<leader>z", function()
    require("zen-mode").toggle()
    vim.cmd('silent !tmux resize-pane -Z')
    ColorMyPencils()
end)
