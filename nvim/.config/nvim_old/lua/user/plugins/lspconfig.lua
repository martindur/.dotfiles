local buf_option = vim.api.nvim_buf_set_option
local buf_keymap = require('lib.utils').buf_keymap
local utils = require('lib.utils')

local lsp_util = require('lspconfig/util')

-- LSP INSTALLERS
local lsp_installer = require("nvim-lsp-installer")

-- Automatically installs LSPs in servers list
local servers = { 'pyright', 'sumneko_lua', 'html', 'sqlls' }
for _, lsp in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(lsp)
    if server_is_found and not server:is_installed() then
        print("Installing " .. lsp)
        server:install()
    end
end


-- Defines keymaps to active on LSP attachments
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end


-- Handles any extra config required for LSPs
lsp_installer.on_server_ready(function(server)
    local server_opts = {
        on_attach = on_attach,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150,
        }
    }

    if server.name == 'pyright' then
      before_init = function(_, config)
        local p
        if vim.env.VIRTUAL_ENV then
          p = lsp_util.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
        else
          p = utils.find_cmd('python', 'venv/bin', config.root_dir)
        end
        config.settings.python.pythonPath = p
        --config.settings.python.venvPath = config.root_dir
        --config.settings.python.venv = 'venv'
    end
    server_opts['before_init'] = before_init
end
    server:setup(server_opts)
end)

