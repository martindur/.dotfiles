local M = {}

local chat_session_file = vim.fn.stdpath("cache") .. "/ai/session.json"

function M.write_session_file(payload)
  if not vim.fs.find({'ai'}, {type='directory', path=vim.fn.stdpath('cache')})[1] then
    vim.fn.mkdir(vim.fn.stdpath('cache') .. '/ai')
  end
  vim.fn.writefile({ payload }, chat_session_file)
end

return M
