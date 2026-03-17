--- http.lua
--- Lightweight API client using curl.
--- Constructs a factory with common verbs like GET and POST

local M = {}

-- low-level request function using curl
-- @param method HTTP verb
-- @param url Full URL
-- @param headers Table of curl-style headers
-- @param body Optional string body
-- @param callback fun(err, result)
function M.request(method, url, headers, body, callback)
  local args = { "-X", method, url, "-s" }
  for _, h in ipairs(headers or {}) do
    table.insert(args, "-H")
    table.insert(args, h)
  end
  if body then
    table.insert(args, "-d")
    table.insert(args, body)
  end

  vim.system({ "curl", unpack(args) }, { text = true }, function(res)
    local ok, parsed = pcall(vim.json.decode, res.stdout)
    callback(res.code ~= 0 and res.stderr or nil, ok and parsed or res.stdout)
  end)
end

function M.stream(url, headers, on_chunk, body)
  local args = { "-s", "-N", url, "-X", "POST" } -- -N disables buffering

  for _, h in ipairs(headers or {}) do
    table.insert(args, "-H")
    table.insert(args, h)
  end

  if body then
    table.insert(args, "-d")
    table.insert(args, body)
  end

  local uv = vim.uv
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()
  local handle, _ = uv.spawn("curl", {
    args = args,
    stdio = { nil, stdout, stderr },
  }, function()
    if handle then
      uv.close(handle)
    end
  end)

  local function stop()
    if handle then uv.process_kill(handle, "sigterm") end
    if stdout then uv.shutdown(stdout, function() uv.close(stdout) end) end
    if stderr then uv.shutdown(stderr, function() uv.close(stderr) end) end
  end

  uv.read_start(stdout, function(err, chunk)
    if err then
      vim.schedule(function()
        on_chunk("Error reading stdout: " .. err)
      end)
      stop()
      return
    end

    if chunk then
      vim.schedule(function() on_chunk(chunk) end)
    end
  end)

  uv.read_start(stderr, function(_, chunk)
    if chunk then
      vim.schedule(function()
        vim.notify("curl stderr: " .. chunk, vim.log.levels.WARN)
      end)
    end
  end)

  return stop
end

--- Creates a new API instance with base_url and headers pre-set.
--- @param config table with base_url (string) and headers (table)
--- @return table with get/post/request methods
function M.new(config)
  assert(config.base_url, "base_url is required")
  config.headers = config.headers or {}

  local function build_url(path)
    return config.base_url .. path
  end

  local function headers_to_array(extra)
    local h = vim.tbl_extend("force", config.headers, extra or {})
    local lines = {}
    for k, v in pairs(h) do
      table.insert(lines, ("%s: %s"):format(k, v))
    end
    return lines
  end

  return {
    get = function(path, callback)
      return M.request("GET", build_url(path), headers_to_array(), nil, callback)
    end,

    post = function(path, body, callback)
      return M.request("POST", build_url(path), headers_to_array(), vim.json.encode(body), callback)
    end,

    request = function(method, path, opts, callback)
      return M.request(method, build_url(path), headers_to_array(opts.headers), opts.body, callback)
    end,

    stream = function(path, on_chunk, body)
      return M.stream(build_url(path), headers_to_array(), on_chunk, body)
    end
  }
end

return M
