local ai = require('ai')

vim.keymap.set('n', '<cr>', function() ai.chat_completion('openai') end, { desc = "generates completion for the current buffer" })
