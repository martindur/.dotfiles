local M = {}
local worktree_sequence = 0

local function run(command, options, callback)
  vim.system(command, {
    cwd = options.cwd,
    text = true,
  }, function(result)
    vim.schedule(function()
      callback(result)
    end)
  end)
end

local function notify_command_error(stage, result)
  local details = result.stderr
  if not details or details == "" then
    details = result.stdout
  end
  if not details or details == "" then
    details = ("command exited with status %d"):format(result.code)
  end

  vim.notify(
    ("%s: %s"):format(stage, vim.trim(details)),
    vim.log.levels.ERROR
  )
end

local function check_dependencies()
  local missing = {}

  for _, command in ipairs({ "codex", "git" }) do
    if vim.fn.executable(command) == 0 then
      table.insert(missing, command)
    end
  end

  if #missing == 0 then
    return true
  end

  vim.notify(
    "CodexWork requires these commands: " .. table.concat(missing, ", "),
    vim.log.levels.ERROR
  )
  return false
end

local function create_worktree_path(repository)
  worktree_sequence = worktree_sequence + 1

  local worktree_root = vim.fs.joinpath(
    vim.fn.stdpath("data"),
    "codex-worktrees",
    vim.fs.basename(repository)
  )
  local unique_name = ("%s-%d-%d"):format(
    os.date("%Y%m%d-%H%M%S"),
    vim.fn.getpid(),
    worktree_sequence
  )

  vim.fn.mkdir(worktree_root, "p")
  return vim.fs.joinpath(worktree_root, unique_name)
end

local function planning_prompt(issue_url)
  return ([[
Use the Linear MCP to read and understand this issue: %s

Retrieve the issue's exact Git branch name from Linear.

This worktree is detached at the latest origin/main. Remain in normal
interactive mode; do not enter Plan mode. Do not create a branch or modify files
yet.

Inspect the repository, the applicable AGENTS.md instructions, and the relevant
implementation. Present a concrete implementation plan covering the intended
changes, module boundaries, and verification. Include the exact Linear Git
branch name in the plan.

Stop and wait for my response. Only after I explicitly say `go`, create the
branch using the exact name from Linear and implement the approved plan.
]]):format(issue_url)
end

local function open_codex_tab(worktree, issue_url)
  vim.cmd.tabnew()
  vim.cmd("tcd " .. vim.fn.fnameescape(worktree))

  local job = vim.fn.jobstart({
    "codex",
    "--sandbox",
    "workspace-write",
    "--ask-for-approval",
    "on-request",
    "--cd",
    worktree,
    vim.trim(planning_prompt(issue_url)),
  }, {
    term = true,
    cwd = worktree,
  })

  if job <= 0 then
    vim.notify("CodexWork could not start Codex.", vim.log.levels.ERROR)
  end
end

function M.start(issue_url)
  if issue_url == "" then
    vim.notify("CodexWork requires a Linear issue URL.", vim.log.levels.ERROR)
    return
  end

  if not check_dependencies() then
    return
  end

  local cwd = vim.fn.getcwd()
  vim.notify("CodexWork: finding repository…")

  run({
    "git",
    "rev-parse",
    "--show-toplevel",
  }, { cwd = cwd }, function(repository_result)
    if repository_result.code ~= 0 then
      notify_command_error("CodexWork could not find the repository", repository_result)
      return
    end

    local repository = vim.trim(repository_result.stdout or "")
    if repository == "" then
      vim.notify(
        "CodexWork: Git returned an empty repository path.",
        vim.log.levels.ERROR
      )
      return
    end

    vim.notify("CodexWork: updating origin/main…")

    run({
      "git",
      "fetch",
      "origin",
      "main",
    }, { cwd = repository }, function(fetch_result)
      if fetch_result.code ~= 0 then
        notify_command_error("CodexWork could not update origin/main", fetch_result)
        return
      end

      local worktree = create_worktree_path(repository)
      vim.notify("CodexWork: creating worktree…")

      run({
        "git",
        "worktree",
        "add",
        "--detach",
        worktree,
        "origin/main",
      }, { cwd = repository }, function(worktree_result)
        if worktree_result.code ~= 0 then
          notify_command_error("CodexWork could not create the worktree", worktree_result)
          return
        end

        open_codex_tab(worktree, issue_url)
      end)
    end)
  end)
end

return M
