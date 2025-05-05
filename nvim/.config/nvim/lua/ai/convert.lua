local M = {}

function M.buffer_text_to_messages(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local text = table.concat(lines, "\n")

  local raw_messages = vim.split(text, "-----", { plain = true })

  local messages = {}
  for _, chunk in ipairs(raw_messages) do
    chunk = vim.trim(chunk)
    if chunk ~= "" then
      -- matching: **ROLE**\nCONTENT
      local role, content = chunk:match("%*%*(%u+)%*%*:%s*\n(.*)")
      if role and content then
        table.insert(messages, {
          role = role:lower(),
          content = vim.trim(content)
        })
      end
    end
  end

  return messages
end

function M.messages_to_buffer_text(messages)
  return "TODO"
end

return M
