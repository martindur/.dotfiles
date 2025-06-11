local util = require('util')
-- local peekaboo = require('peekaboo')

vim.g.mapleader = " "

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.completeopt = { 'menu', 'popup', 'noinsert', 'fuzzy' }

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true

vim.opt.wildignore = { '__pycache__', 'node_modules' }
vim.opt.listchars = { space = '_', tab = '>~' }


---------
-- LSP --
---------

require('lsp').setup()


-- LSP AUTO COMPLETE --

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
--     if client:supports_method('textDocument/completion') then
--       -- Trigger autocompletion on EVERY keypress. May be slow!
--       --local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
--       --client.server_capabilities.completionProvider.triggerCharacters = chars
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--     end
--   end
-- })

vim.diagnostic.config({ virtual_lines = true })

-- KEY MAP --

vim.keymap.set({ 'n', 'v' }, 'J', '10j')
vim.keymap.set({ 'n', 'v' }, 'K', '10k')
vim.keymap.set('i', 'jk', '<esc>')

-- File finding --
vim.keymap.set({ 'n' }, '<leader>g', function() util.floating_process('lazygit') end)
vim.keymap.set({ 'n' }, '<leader>e', function() util.floating_process('yazi') end)

-- vim.keymap.set({ 'n' }, '<leader>f', peekaboo.find_files, { desc = "find project files with fzf" })
-- vim.keymap.set({ 'n' }, '<leader>b', peekaboo.find_buffers, { desc = "find files from current buffers" })
-- vim.keymap.set({ 'n' }, '<leader>F', peekaboo.find_files_include_hidden, { desc = "find files, including hidden" })
-- vim.keymap.set({ 'n' }, '<leader>t', function() peekaboo.live_grep() end,
--   { desc = "find files by searching for string in file" })
-- vim.keymap.set({ 'n' }, ',', peekaboo.last_query, { desc = "re-run last query" })

-- vim.keymap.set('n', '<leader>p', require("ai").new_chat)


--require('witch').setup()

-- FUNCTIONALITY --

-- search git log (keeps the selected item while searching, provided it matches):
-- git log --oneline --graph --color=always | nl | fzf --ansi --track --no-sort --layout=reverse-list

-- search (and execute?) command history:
-- history | fzf --tac --no-sort

-- TODO:
-- * quick open terminal (toggleable?)
-- * simple which key
-- * consolidate themes (keep habamax?)
-- * AI buffer v1 (simple buffer chat)
-- * AI buffer v2 (context via vectorized database of code, using pgvector)
--

-- PLUGINS

vim.cmd('source ' .. vim.fn.stdpath("config") .. '/plugme.vim')
vim.cmd.colorscheme("kanagawa")
-- .ass is used for AI assistant filetype
require('render-markdown').setup({
  file_types = { 'markdown', 'ass', 'codecompanion' }
})
vim.treesitter.language.register('markdown', 'ass')

require('nvim-treesitter.configs').setup({
  highlight = { enable = true }
})


local fzflua = require('fzf-lua')
fzflua.setup({
  "hide" -- hide the fzf process when closing, for a better resume experience
})

vim.keymap.set({ 'n' }, '<leader>f', fzflua.files, { desc = "find project files with fzf" })
vim.keymap.set({ 'n' }, '<leader>b', fzflua.buffers, { desc = "find files from current buffers" })
vim.keymap.set({ 'n' }, '<leader>t', fzflua.tabs, { desc = "switch tabs" })
-- vim.keymap.set({ 'n' }, '<leader>F', peekaboo.find_files_include_hidden, { desc = "find files, including hidden" })
vim.keymap.set({ 'n' }, '<leader>t', fzflua.live_grep_native,
  { desc = "find files by searching for string in file" })
vim.keymap.set({ 'n' }, '<leader>w', fzflua.grep_cword, { desc = "grep word under cursor" })
vim.keymap.set({ 'n' }, ',', fzflua.resume, { desc = "re-run last query" })




require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = {
        name = "openai",
        model = "o4-mini-2025-04-16", -- ideal for coding (fast)
        --model = "o3-2025-04-16", -- ideal for research, planning (slow)
      },
      slash_commands = {
        ["git_files"] = {
          description = "List git files",
          ---@param chat CodeCompanion.Chat
          callback = function(chat)
            local handle = io.popen("git ls-files")
            if handle ~= nil then
              local result = handle:read("*a")
              handle:close()
              chat:add_reference({ role = "user", content = result }, "git", "<git_files>")
            else
              return vim.notify("No git files available", vim.log.levels.INFO)
            end
          end,
          opts = {
            contains_code = false
          }
        }
      },
      keymaps = {
        completion = {
          modes = {
            i = "<C-.>"
          }
        }
      },
      tools = {
        opts = {
          auto_submit_errors = false,
          auto_submit_success = true
        }
      }
    },
    inline = {
      adapter = "openai"
    }
  },
  extensions = {
    history = {
      enable = true
    },
    vectorcode = {
      opts = {
        add_tool = true
      }
    }
  }
})

vim.keymap.set('n', '<leader>ca', '<cmd>CodeCompanionActions<cr>', { desc = "AI Actions" })
vim.keymap.set('n', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { desc = "AI Chat" })

-- CONFORM (FORMATTING) --
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    astro = { "prettierd", "prettier", stop_after_first = true },
    svelte = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback"
  }
})


-- AUTOCOMPLETION --
require('blink.cmp').setup()
