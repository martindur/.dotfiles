--require("dur.core") -- configs
--require("dur.lazy") -- plugins

-- Testing out "raw" single file

vim.cmd('syntax enable')

vim.g.mapleader = ' '
vim.keymap.set({ "n", "x", "v" }, "J", "10j", { silent = true })
vim.keymap.set({ "n", "x", "v" }, "K", "10k", { silent = true })

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.wrap = true

vim.opt.clipboard:append("unnamedplus")

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  desc = "Briefly highlight yanked text"
})


--
--------- LSP ---------
--

-- Elixir LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = "elixir", -- nvim has filetype detection, and understands .ex files are "elixir" filetypes
  callback = function(args)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.start({
      name = 'elixir-ls',
      cmd = { 'elixir-ls' },
      root_dir = vim.fs.dirname(vim.fs.find({ 'mix.exs' }, { upward = true })[1]),
      capabilities = capabilities
    })
  end
})

-- Lua LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = "lua", -- nvim has filetype detection, and understands .ex files are "elixir" filetypes
  callback = function(args)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.start({
      name = 'lua-ls',
      cmd = { 'lua-language-server' },
      capabilities = capabilities
    })
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    --vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    --vim.bo.tagfunc = 'v:lua.vim.lsp.tagfunc'

    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    vim.keymap.set('n', 'gr', vim.lsp.buf.rename, { buffer = args.buf })
  end,
})


--
-------- PLUGINS --------
--

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

-- telescope (workspace navigation with fuzzy finding)
local telescope = {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.4',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim',     build = 'make' },
    { 'nvim-telescope/telescope-live-grep-args.nvim', version = '^1.0.0' }
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local lg_actions = require('telescope-live-grep-args.actions')

    telescope.setup({
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = " -t" }),
              ["<C-i>"] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = " --iglob " }),
            },
          },
        }

      }
    })

    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")

    -- General keymaps
    vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>s', telescope.extensions.live_grep_args.live_grep_args, { desc = 'Live grep with args' })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find in buffers' })
  end
}

-- Treesitter (syntax highlighting and "understanding" of file structure)
local treesitter = {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query", "python", "html", "css", "scss",
        "elixir", "eex", "heex", "javascript", "typescript", "go", "rust", "svelte",
        "json", "yaml", "bash", "dockerfile", "erlang", "fish", "graphql", "make",
        "markdown", "sql", "toml",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true }
    })
  end
}

-- Completion engine (e.g. box with suggestions for code-completion)
local completion = {
  'hrsh7th/nvim-cmp',
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    -- sources for the engine
    'hrsh7th/cmp-nvim-lsp', -- pulling suggestions from active LSP
    'hrsh7th/cmp-buffer',   -- pulling suggestions from active buffer
    -- snippet engine support
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip'
  },
  config = function()
    local cmp = require('cmp')

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    cmp.setup({
      -- small config to enable snippet engage
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      -- completion sources, e.g. LSP and buffer
      sources = cmp.config.sources(
        {
          { name = 'nvim_lsp' },
        },
        {
          { name = 'buffer' }
        }
      ),
      -- key mappings
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" }),
      }
    })
  end
}

-- NvimTree (just a really useful and vim-like tree explorer)
local neotree = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim"
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("neo-tree").setup()

    -- keymaps
    local keymap = vim.keymap

    keymap.set("n", "<leader>o", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>e", "<cmd>Neotree<CR>", { desc = "Focus file explorer" })
  end
}

local autopairs = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {} -- this is equivalent to setup({}) function
}

local colorscheme = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("tokyonight").setup({ style = "moon" })
  end
}

-- convenient way to disable/enable specific plugins
local plugins = {
  telescope,
  treesitter,
  neotree,
  autopairs,
  completion,
  colorscheme
}

local config = {
  install = {
    colorscheme = { "tokyonight" },
  },
}

require('lazy').setup(plugins, config)

vim.cmd.colorscheme("tokyonight")
