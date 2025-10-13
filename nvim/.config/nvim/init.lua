local util = require('util')

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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = args.buf })
    -- vim.keymap.set('n', '<leader>r', tsb.lsp_references, { buffer = args.buf })
  end
})

-- KEY MAP --

vim.keymap.set({ 'n', 'v' }, 'J', '10j')
vim.keymap.set({ 'n', 'v' }, 'K', '10k')
vim.keymap.set('i', 'jk', '<esc>')

-- File finding --
vim.keymap.set({ 'n' }, '<leader>g', function() util.floating_process('lazygit') end)
vim.keymap.set({ 'n' }, '<leader>e', function()
  local dir = vim.fn.expand('%:p:h')
  if dir == '' then dir = vim.loop.cwd() end
  util.floating_process('yazi "' .. dir .. '"')
end)

vim.keymap.set({ 'n' }, '<leader>1', '<cmd>tabn 1<cr>')
vim.keymap.set({ 'n' }, '<leader>2', '<cmd>tabn 2<cr>')
vim.keymap.set({ 'n' }, '<leader>3', '<cmd>tabn 3<cr>')
vim.keymap.set({ 'n' }, '<leader>4', '<cmd>tabn 4<cr>')
vim.keymap.set({ 'n' }, '<leader>5', '<cmd>tabn 5<cr>')

vim.keymap.set({ 't' }, '<c-x>', '<c-\\><c-n>')

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
vim.cmd.colorscheme("tokyonight-night")
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
  "hide", -- hide the fzf process when closing, for a better resume experience
  buffers = {
    cwd_only = true,
    -- no_term_buffers = false
    -- current_tab_only = true,
    show_unlisted = true,
    show_unloaded = true
  }
})

vim.keymap.set({ 'n' }, '<leader>f', fzflua.files, { desc = "find project files with fzf" })
vim.keymap.set({ 'n' }, '<leader>b', fzflua.buffers, { desc = "find files from current buffers" })
vim.keymap.set({ 'n' }, '<leader>t', fzflua.tabs, { desc = "switch tabs" })
-- vim.keymap.set({ 'n' }, '<leader>F', peekaboo.find_files_include_hidden, { desc = "find files, including hidden" })
vim.keymap.set({ 'n' }, '<leader>t', fzflua.live_grep_native,
  { desc = "find files by searching for string in file" })
vim.keymap.set({ 'n' }, '<leader>w', fzflua.grep_cword, { desc = "grep word under cursor" })
vim.keymap.set({ 'n' }, ',', fzflua.resume, { desc = "re-run last query" })

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
  underline = { severity = { min = vim.diagnostic.severity.ERROR } },
  signs = { severity = { min = vim.diagnostic.severity.WARN } },
})


-- require('mcphub').setup({
--   config = vim.fn.expand("~/.config/mcphub/servers.json"),
--   port = 37373,
--   workspace = {
--     enabled = true,
--     look_for = { ".mcphub/servers.json" }
--   }
-- })

require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = {
        name = "copilot",
        model = "claude-4.5",
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
        },
        ["cmd_runner"] = {
          requires_approval = true,
        },
        ["create_file"] = {
          requires_approval = false
        },
        ["insert_edit_into_file"] = {
          requires_approval = { buffer = false, file = false },
          user_confirmation = false
        }
      }
    },
    inline = {
      adapter = "copilot",
      model = "claude-4.5"
    }
  },
  extensions = {
    history = {
      enable = true
    },
    -- vectorcode = {
    --   opts = {
    --     add_tool = true
    --   }
    -- },
    -- mcphub = {
    --   callback = "mcphub.extensions.codecompanion",
    --   opts = {
    --     make_tools = true,
    --     show_server_tools_in_chat = true,
    --     add_mcp_prefix_to_tool_names = false,
    --     show_result_in_chat = true,
    --     format_tool = nil,
    --     make_vars = true,
    --     make_slash_commands = true
    --   }
    -- }
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

-- PROJECTS --
-- require('projects').setup({
--   pick = { root = vim.fn.expand('~') .. '/projects', depth = 1 },
--   set_tabline = true
-- })
--
-- vim.keymap.set('n', '<leader>pp', function() require('projects').pick() end)
-- vim.keymap.set('n', '<leader>pr', function()
--   vim.ui.input({ prompt = 'Rename tab:' }, function(name)
--     if name then require('projects').rename(name) end
--   end)
-- end)
