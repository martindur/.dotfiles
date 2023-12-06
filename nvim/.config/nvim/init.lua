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
--------- GENERAL ---------
--

-- Detect filetypes for new files (even before saved)
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*',
  callback = function(args)
    vim.cmd("filetype detect")
  end
})

--
--------- LSP ---------
--

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

    --vim.opt.statusline:append("lua-ls")
  end
})


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
    --vim.opt.statusline:append("elixir-ls")
  end
})

-- Html LSP
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  pattern = {"*.html", "*.heex"},
  callback = function(args)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.start({
      name = 'vscode-html-languageserver',
      cmd = { 'vscode-html-languageserver', '--stdio' },
      capabilities = capabilities
    })

    --vim.opt.statusline:append("html-ls")
  end
})

-- Emmet LSP (A faster way to do web dev)
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  pattern = {"*.css", "*.html", "*.heex", "*.jsx", "*.scss", "*.tsx"},
  callback = function(args)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.start({
      name = 'emmet-ls',
      cmd = { 'emmet-language-server', '--stdio' },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
      capabilities = capabilities
    })
  end
})

-- Python LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = "python",
  callback = function(args)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.start({
      name = 'pyright-ls',
      cmd = { 'pyright-langserver', '--stdio' },
      root_dir = vim.fs.dirname(vim.fs.find({ 'requirements.txt', 'pyproject.toml', '.venv' }, { upward = true })[1]),
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
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = args.buf })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = args.buf })
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
  lazy = false,
  priority = 999,
  build = ':TSUpdate',
  cmd = { "TSUpdateSync" },
  dependencies = {
    'windwp/nvim-ts-autotag'
  },
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
      indent = { enable = true },
      autotag = {
        enable = true,
        filetypes = { "html", "elixir", "heex", "javascript", "typescript", "svelte", "markdown", "xml" }
      }
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
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')

    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done()) -- make sure autopairs works when doing auto-completions

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    local next_suggestion = function()
      return cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        --elseif has_words_before() then -- I prefer explicit selection for completion, but keeping this for reference
          --cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" })
    end

    local prev_suggestion = function()
      return cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" })
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
        ["<Tab>"] = next_suggestion(),
        ["<Down>"] = next_suggestion(),
        ["<S-Tab>"] = prev_suggestion(),
        ["<Up>"] = prev_suggestion(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        --["<Esc>"] = cmp.mapping.close(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4)
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

local ts_autotag = { -- this is not in "plugins", but instead a dependency on both autopairs, and treesitter
  "windwp/nvim-ts-autotag",
  config = function()
    require('nvim-ts-autotag').setup({})
  end,
  lazy = true
}

local autopairs = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    'windwp/nvim-ts-autotag'
  },
  config = function()
    require('nvim-autopairs').setup()
  end
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
