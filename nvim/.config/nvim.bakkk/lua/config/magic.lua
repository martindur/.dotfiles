
local function tab_or_right()
    -- Search for closing brackets/quotes after cursor
    if vim.fn.search([[\%#[]>)}'"]], 'n') > 0 then
        return '<right>'
    end
    return '<tab>'
end

-- Create the mapping using expr-mode
vim.keymap.set('i', '<Tab>', tab_or_right, { expr = true })

-- Move to first '(' on line and select the word before it
vim.keymap.set('o', 'F', function()
    vim.cmd.normal('0f(hviw')
end, { silent = true })

-- Select inside parentheses
vim.keymap.set('o', 'p', 'i(', { silent = true })

-- Move to next 'return' keyword
vim.keymap.set('o', 'b', '/return<cr>', { silent = true })
