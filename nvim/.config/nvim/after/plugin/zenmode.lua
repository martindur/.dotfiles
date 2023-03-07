require("zen-mode").setup {
    window = {
        width = 180,
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
