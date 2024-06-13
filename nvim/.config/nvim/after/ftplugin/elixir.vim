set cms=#\ %s

:iabbrev <buffer> pp \|>
:iabbrev <buffer> xc <%= %><left><left><left>
:iabbrev <buffer> xx <% %><left><left><left>
:iabbrev <buffer> hh ~H"""<cr>"""<up><right><right><cr>

lua << EOF

-- LSP

elixir_lsp_config = {
    name = 'elixir-ls',
    cmd = { 'elixir-ls' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'mix.exs' }, { upward = true })[1]),
    on_attach = lsp_attach
}

next_ls_config = {
    name = 'next-ls',
    cmd = { 'nextls', '--stdio' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'mix.exs' }, { upward = true })[1]),
    on_attach = lsp_attach,
    settings = {
        experimental = {
            completions = {
                enable= true
            }
        }
    }
}

-- DAP

local dap = require "dap"
local ui = require "dapui"

local elixir_debugger = vim.fn.exepath "elixir-debugger"

if elixir_debugger ~= "" then
    dap.adapters.mix_task = {
        type = 'executable',
        command = elixir_debugger
    }

    dap.configurations.elixir = {
        {
            type = "mix_task",
            name = "phoenix server",
            task = "phx.server",
            request = "launch",
            projectDir = "${workspaceFolder}",
            exitAfterTaskReturns = false,
            debugAutoInterpretAllModules= false
        }
    }

    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>dd', dap.run_to_cursor)
    vim.keymap.set('n', '<leader>?', function ()
        require('dapui').eval(nil, { enter = true })
    end)

    --vim.keymap.set('n', '<leader>dc', dap.continue)
    --vim.keymap.set('n', '<leader>si', dap.step_into)
    --vim.keymap.set('n', '<leader>so', dap.step_out)
    --vim.keymap.set('n', '<leader>sb', dap.step_back)
    --vim.keymap.set('n', '<leader>do', dap.step_over)
    --vim.keymap.set('n', '<leader>dr', dap.restart)

    vim.keymap.set('n', '<F1>', dap.continue)
    vim.keymap.set('n', '<F2>', dap.step_into)
    vim.keymap.set('n', '<F3>', dap.step_over)
    vim.keymap.set('n', '<F4>', dap.step_out)
    vim.keymap.set('n', '<F5>', dap.step_back)
    vim.keymap.set('n', '<F6>', dap.restart)

    dap.listeners.before.attach.dapui_config = function()
        ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
    end
else
    print("Debugger not available")
end

EOF

call luaeval('start_lsp(elixir_lsp_config)')

augroup elixir_format
    autocmd!
    autocmd BufWritePost <buffer> :silent execute '!mix format '.bufname("%")
augroup end
