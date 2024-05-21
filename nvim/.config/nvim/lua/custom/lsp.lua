-- https://neovim.io/doc/user/lsp.html#vim.lsp.start()
-- https://neovim.io/doc/user/lsp.html#vim.lsp.ClientConfig

-- FUNCTIONS
--
local function serialize_table(t, indent)
    local serialized = ""
    local indent = indent or ""
    local next_indent = indent .. " "


    for k, v in pairs(t) do
        serialized = serialized .. indent .. tostring(k) .. ": "

        if type(v) == "table" then
            serialized = serialized .. "\n".. serialize_table(v, next_indent)
        else
            serialized = serialized .. tostring(v) .. "\n"
        end
    end

    return serialized
end

function start_lsp(config)
-- https://github.com/hrsh7th/cmp-nvim-lsp
-- may have more capabilities for completion
    local capabilities = nil
    if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
    end

    if capabilities then
        config = vim.tbl_deep_extend("force", {}, {
            capabilities = capabilities,
        }, config)
    end

    vim.lsp.start(config)
end

function lsp_info(debug)
    local clients = vim.lsp.get_active_clients()
    if #clients == 0 then
        print("No active LSP clients")
        return
    end

    local lines = {}
    for _, client in ipairs(clients) do
        if debug then
            local client_info = serialize_table(client)
            for _, line in ipairs(vim.split(client_info, '\n')) do
                table.insert(lines, line)
            end
        else
            table.insert(lines, string.format("ID: %d - Name: %s", client.id, client.name))
            --table.insert(lines, "Capabilities:")
            --local capabilities_info = serialize_table(client.resolved_capabilities or client.server_capabilities)
            -- for _, line in ipairs(vim.split(capabilities_info, '\n')) do
            --     table.insert(lines, " " .. line)
            -- end
        end

        table.insert(lines, "")
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local win_opts = {
        relative = 'editor',
        width = 60,
        height = 30,
        col = vim.o.columns / 2 - 30,
        row = vim.o.lines / 2 - 15,
        style = 'minimal',
        border = 'single'
    }

    vim.api.nvim_open_win(buf, true, win_opts)
end


function lsp_attach(client, bufnr)
    -- Python specific
    if client.name == 'ruff-ls' then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end

    if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    if client.server_capabilities.definitionProvider then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { buffer = bufnr })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
end

-- MAPPINGS / COMMANDS

vim.api.nvim_create_user_command('LspInfo', function() lsp_info(false) end, {})
vim.api.nvim_create_user_command('LspInfoDebug', function() lsp_info(true) end, {})
