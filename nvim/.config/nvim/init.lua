local util = require('util')
local peekaboo = require('peekaboo')

vim.g.mapleader = " "
vim.cmd.colorscheme("habamax")

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

-- LUA --
vim.lsp.config.lua_ls = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc'},
	telemetry = { enabled = false },
	formatters = {
		ignoreComments = false,
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT"
			},
			signatureHelp = { enabled = true }
		}
	}
}

vim.lsp.enable("lua_ls")


-- LSP AUTO COMPLETE --

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method('textDocument/completion') then
      -- Trigger autocompletion on EVERY keypress. May be slow!
      --local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      --client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end
})

vim.diagnostic.config({ virtual_lines = true })

-- KEY MAP --

vim.keymap.set({'n', 'v'}, 'J', '10j')
vim.keymap.set({'n', 'v'}, 'K', '10k')
vim.keymap.set('i', 'jk', '<esc>')

-- File finding --
vim.keymap.set({'n'}, '<leader>g', function() util.floating_process('lazygit') end)
vim.keymap.set({'n'}, '<leader>e', function() util.floating_process('yazi') end)

-- local find_files = {
--   'fzf',
--   '--preview', 'bat --style=numbers --color=always {}',
--   '--bind', "ctrl-.:reload(fd --type f --hidden --exclude .git --include '.*')",
  -- '--header', 'CTRL-. show hidden'
-- }

vim.keymap.set({'n'}, '<leader>f', peekaboo.find_files, { desc = "find project files with fzf"})
vim.keymap.set({'n'}, '<leader>b', peekaboo.find_buffers, { desc = "find files from current buffers"})
vim.keymap.set({'n'}, '<leader>F', peekaboo.find_files_include_hidden, { desc = "find files, including hidden" })
vim.keymap.set({'n'}, '<leader>t', function() peekaboo.live_grep() end, { desc = "find files by searching for string in file" })
vim.keymap.set({'n'}, ',', peekaboo.last_query, { desc = "re-run last query" })
-- vim.keymap.set('i', '<c-space>', function() vim.lsp.completion.get() end) -- switches language in OSX


vim.keymap.set('n', '<leader>p', require("ai").new_chat)


--require('witch').setup()

-- Maybe?
--vim.keymap.set('i', '<Tab>', function()
--  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
--end)


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
-- .ass is used for AI assistant filetype
require('render-markdown').setup({
  file_types = { 'markdown', 'ass', 'codecompanion' }
})
vim.treesitter.language.register('markdown', 'ass')

require('nvim-treesitter.configs').setup({
  highlight = { enable = true }
})

require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = "anthropic",
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
      adapter = "anthropic"
    }
  }
})

vim.keymap.set('n', '<leader>ca', '<cmd>CodeCompanionActions<cr>', { desc = "AI Actions" })
vim.keymap.set('n', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { desc = "AI Chat" })

local diff = require('mini.diff')

diff.setup({
  source = diff.gen_source.none()
})
