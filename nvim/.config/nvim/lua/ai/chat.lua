local session = require("ai.session")
local convert = require("ai.convert")

local M = {}

local function chat_template(role, content)
  if content then
    return { "-----", "**" .. role:upper() .. "**:", content }
  end

  return { "-----", "**" .. role:upper() .. "**:" }
end


function M.new(placeholder)
  vim.cmd("vertical new")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value('filetype', 'ass', { buf = bufnr })

  placeholder = placeholder or "write me a haiku about neovim"

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, chat_template("user", placeholder))
  vim.api.nvim_win_set_cursor(0, { 3, vim.fn.strlen(placeholder) })
end


function M.completion(bufnr, callback)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
  if ft ~= 'ass' then
    vim.notify('Buffer is not an ass. Unsupported filetype: ' .. ft, vim.log.levels.ERROR)
    return
  end

  local dev_message = {
    {
      role = "developer",
      content = [[
      You are a helpful senior software AI engineer that is sparring with another senior software engineer. Be concise, and not overly verbose.
      If you want information about the current project your sparring partner is working on, use a query tool. Using a query tool is done like this:

      <query>
      button
      </query>

      this will return file paths and contents that match your query.
      ]]
    }
  }

  local payload = vim.json.encode({
    model = "gpt-4.1",
    stream = true,
    messages = vim.list_extend(dev_message, convert.buffer_text_to_messages(bufnr))
  })

  -- save user message
  vim.schedule(function()
    session.write_session_file(payload)
  end)


  vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "", "-----", "**ASSISTANT**:", "" })

  local cancel_stream = callback(payload)

  _G.cancel_completion = cancel_stream
end

return M
