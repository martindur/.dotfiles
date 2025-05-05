local http = require("http")
local chat = require("ai.chat")
local parsers = require("ai.parsers")

local M = {}

local ollama = http.new({
  base_url = "http://localhost:11434",
  headers = {
    ["Content-Type"] = "application/json"
  }
})

local openai = http.new({
  base_url = "https://api.openai.com/v1",
  headers = {
    ["Content-Type"] = "application/json",
    Authorization = "Bearer " .. vim.env.OPENAI_API_KEY
  }
})

local adapters = function(adapter, buf)
  local options = {
    ollama = function(payload)
      ollama.stream("/api/chat", parsers.ollama_stream(buf), payload)
    end,
    openai = function(payload)
      openai.stream("/chat/completions", parsers.openai_stream(buf), payload)
    end
  }

  return options[adapter]
end


M.new_chat = function()
  chat.new("Chat here..")
end


M.chat_completion = function(adapter, buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local completion_handler = adapters(adapter, buf)

  chat.completion(buf, completion_handler)
end

return M
