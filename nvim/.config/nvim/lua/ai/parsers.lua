local session = require('ai.session')
local convert = require('ai.convert')

local M = {}

M.openai_stream = function(bufnr)
  return function(chunk)
    for line in chunk:gmatch("[^\r\n]+") do
      if line == "data: [DONE]" then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "", "-----", "**USER**:", "", "" })

        local line_count = vim.api.nvim_buf_line_count(bufnr)

        vim.api.nvim_win_set_cursor(0, { line_count, 0 })

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

        vim.schedule(function()
          session.write_session_file(payload)
        end)
        return
      end

      local json_part = line:match("^data:%s*(%b{})")
      if json_part then
        json_part = vim.trim(json_part)
        local ok, decoded = pcall(vim.json.decode, json_part)
        if not ok then
          vim.notify('error decoding chunk: ' .. decoded, vim.log.levels.ERROR)
          return
        end

        -- stream message handling
        if ok and #decoded.choices > 0 and decoded.choices[1].delta.content then
          local content = decoded.choices[1].delta.content

          local last_line = vim.api.nvim_buf_get_lines(bufnr, -2, -1, false)[1] or ""
          local merged_content = last_line .. content
          local lines = vim.split(merged_content, "\n", { plain = true })
          vim.api.nvim_buf_set_lines(bufnr, -2, -1, false, lines)
        end
      end
    end
  end
end


local thinking_state = function(content, thinking)
  if content:match("<think>") then
    return true, true
  elseif content:match("</think>") then
    return true, false
  end

  return false, thinking
end


-- M.ollama_stream = function(chunk)
--   local ok, decoded = pcall(vim.json.decode, chunk)
--   if ok and decoded.done then
--     vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "", "-----", "", "**USER:**" })
--
--     local ai_payload = vim.json.encode({
--       model = "gpt-4.1",
--       stream = true,
--       messages = get_messages()
--     })
--
--     -- save assistant message
--     write_session_file(ai_payload)
--   end
--
--   if ok and decoded.message and decoded.message.content then
--     local content = decoded.message.content
--     local switched
--     switched, thinking = thinking_state(content, thinking)
--
--     if switched or thinking then return end -- we don't need to store the metadata tokens
--
--     local last_line = vim.api.nvim_buf_get_lines(bufnr, -2, -1, false)[1] or ""
--     local merged_content = last_line .. content
--     local lines = vim.split(merged_content, "\n", { plain = true })
--     vim.api.nvim_buf_set_lines(bufnr, -2, -1, false, lines)
--   end
-- end

return M
