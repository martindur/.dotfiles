local M = {}

local review_lenses = {
  naming = {
    description = "Evaluate naming clarity and semantic fit",
    prompt = [[
Review the current implementation for naming clarity and semantic fit.

Focus on names introduced, changed, or made relevant by the current work.
Consider variables, functions, types, modules, configuration, states, and public
interfaces.

Assess whether each name:

- clearly communicates the domain concept or responsibility;
- uses vocabulary consistent with the surrounding codebase;
- operates at the right level of abstraction;
- distinguishes the concept from nearby concepts;
- remains accurate beyond its immediate implementation details.

Report only cases where naming materially obscures intent, creates ambiguity, or
introduces inconsistent terminology. Do not flag established language
conventions or suggest changes based merely on personal preference.

For each finding, briefly explain the semantic problem and propose two or three
alternatives representing distinct directions, not just a list of synonyms.
Prefer terminology already established in the codebase, and mention the tradeoff
between the alternatives when it is useful.

Keep findings concise and scoped to the current work. Do not recommend broad
unrelated renaming.
]],
  },
  reuse = {
    description = "Find unnecessary custom implementations",
    prompt = [[
Review the current implementation for unnecessary reinvention.

Look for functionality that already exists:

- elsewhere in this codebase;
- in dependencies already used by the project;
- in the language, standard library, framework, or platform.

Pay particular attention to custom implementations where a native or existing
solution provides most of the required behavior. When the custom implementation
exists for the remaining behavior, assess whether that additional value
justifies its complexity, maintenance burden, and divergence from established
conventions.

Report only concrete, actionable cases. Identify the existing alternative,
explain what it covers, describe the genuinely missing behavior, and state the
relevant tradeoff. Do not flag superficial similarity or recommend adding a
dependency without a clear net benefit.
]],
  },
  tests = {
    description = "Assess critical-path test coverage",
    prompt = [[
Review the current change and its tests for business-critical path coverage.
Judge criticality by failure impact, not code coverage or test count.
Do not run tests.

Output only:

coverage: complete | partial | insufficient

gaps:
- `<critical-path>` — missing: `<scenario>`

tests:
- `<critical-path>`
  - setup: `<state>`, `<inputs>`
  - assert: `<outputs>`, `<state changes>`, `<invariants>`

Include only existing tests that cover critical paths. Consolidate equivalent
cases. Prefer identifiers, values, and state transitions over explanatory
prose. Use `gaps: none` when appropriate.
]],
  },
}

local function set_buffer_content(buffer, lines)
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end

  vim.bo[buffer].modifiable = true
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].modifiable = false
end

local function set_status(buffer, review_name, message)
  set_buffer_content(buffer, {
    ("# Codex Review: %s"):format(review_name),
    "",
    message,
  })
end

local function command_error(stage, result)
  local details = result.stderr
  if not details or details == "" then
    details = result.stdout
  end
  if not details or details == "" then
    details = ("Command exited with status %d."):format(result.code)
  end

  local lines = {
    "# Codex Review",
    "",
    ("Review failed while %s."):format(stage),
    "",
    "```text",
  }

  vim.list_extend(lines, vim.split(vim.trim(details), "\n", { plain = true }))
  table.insert(lines, "```")

  return lines
end

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

local function create_review_buffer(review_name)
  vim.cmd.tabnew()

  local buffer = vim.api.nvim_get_current_buf()
  local buffer_name = review_name:gsub("[^%w_-]", "-")
  vim.api.nvim_buf_set_name(
    buffer,
    ("codex-review://%s/%d"):format(buffer_name, buffer)
  )

  vim.bo[buffer].buftype = "nofile"
  vim.bo[buffer].bufhidden = "wipe"
  vim.bo[buffer].swapfile = false
  vim.bo[buffer].filetype = "markdown"

  vim.keymap.set("n", "q", "<cmd>tabclose<cr>", {
    buffer = buffer,
    silent = true,
    desc = "Close Codex review",
  })

  return buffer
end

local function check_dependencies(commands)
  local missing = {}

  for _, command in ipairs(commands) do
    if vim.fn.executable(command) == 0 then
      table.insert(missing, command)
    end
  end

  return missing
end

local function notify_missing_dependencies(commands)
  local missing = check_dependencies(commands)
  if #missing == 0 then
    return false
  end

  vim.notify(
    "CodexReview requires these commands: " .. table.concat(missing, ", "),
    vim.log.levels.ERROR
  )
  return true
end

local function set_review_result(buffer, result)
  if result.code ~= 0 then
    set_buffer_content(buffer, command_error("running Codex", result))
    return
  end

  local review = vim.trim(result.stdout or "")
  if review == "" then
    review = "Codex completed without returning a review."
  end

  set_buffer_content(buffer, vim.split(review, "\n", { plain = true }))
end

function M.complete(argument)
  local matches = {}

  for lens_name in pairs(review_lenses) do
    if vim.startswith(lens_name, argument) then
      table.insert(matches, lens_name)
    end
  end

  table.sort(matches)
  return matches
end

local function review_lens(lens_name, lens)
  if notify_missing_dependencies({ "codex", "git" }) then
    return
  end

  local buffer = create_review_buffer(lens_name)
  local cwd = vim.fn.getcwd()

  set_status(buffer, lens_name, "Finding the repository…")

  run({
    "git",
    "rev-parse",
    "--show-toplevel",
  }, { cwd = cwd }, function(repository_result)
    if repository_result.code ~= 0 then
      set_buffer_content(
        buffer,
        command_error("finding the repository", repository_result)
      )
      return
    end

    local repository = vim.trim(repository_result.stdout or "")
    if repository == "" then
      set_buffer_content(buffer, {
        "# Codex Review",
        "",
        "Git returned an empty repository path.",
      })
      return
    end

    set_status(buffer, lens_name, lens.description .. "…")

    run({
      "codex",
      "exec",
      "review",
      "--ephemeral",
      vim.trim(lens.prompt),
    }, { cwd = repository }, function(review_result)
      set_review_result(buffer, review_result)
    end)
  end)
end

local function parse_pull_request_url(url)
  local owner, repository, number =
    url:match("^https://github%.com/([^/]+)/([^/]+)/pull/(%d+)/?.*$")

  if not owner then
    return nil
  end

  return {
    owner = owner,
    repository = repository,
    number = number,
  }
end

local function review_pull_request(url, pull_request)
  if notify_missing_dependencies({ "codex", "gh", "git" }) then
    return
  end

  local review_name = ("PR %s/%s#%s"):format(
    pull_request.owner,
    pull_request.repository,
    pull_request.number
  )
  local buffer = create_review_buffer(review_name)
  local temp_root = vim.fn.tempname()
  local repository_dir = vim.fs.joinpath(temp_root, "repository")

  vim.fn.mkdir(temp_root, "p")
  set_status(buffer, review_name, "Loading pull request…")

  local function cleanup()
    vim.fn.delete(temp_root, "rf")
  end

  local function fail(stage, result)
    cleanup()
    set_buffer_content(buffer, command_error(stage, result))
  end

  run({
    "gh",
    "pr",
    "view",
    url,
    "--json",
    "baseRefName",
  }, {}, function(view_result)
    if view_result.code ~= 0 then
      fail("loading the pull request", view_result)
      return
    end

    local decoded, metadata = pcall(vim.json.decode, view_result.stdout)
    if not decoded or type(metadata.baseRefName) ~= "string" then
      fail("reading pull request metadata", {
        code = 1,
        stderr = "GitHub returned invalid pull request metadata.",
      })
      return
    end

    set_status(buffer, review_name, "Cloning repository…")

    run({
      "gh",
      "repo",
      "clone",
      pull_request.owner .. "/" .. pull_request.repository,
      repository_dir,
      "--",
      "--filter=blob:none",
    }, {}, function(clone_result)
      if clone_result.code ~= 0 then
        fail("cloning the repository", clone_result)
        return
      end

      set_status(buffer, review_name, "Checking out pull request…")

      run({
        "gh",
        "pr",
        "checkout",
        pull_request.number,
        "--detach",
      }, { cwd = repository_dir }, function(checkout_result)
        if checkout_result.code ~= 0 then
          fail("checking out the pull request", checkout_result)
          return
        end

        set_status(
          buffer,
          review_name,
          ("Reviewing against %s…"):format(metadata.baseRefName)
        )

        run({
          "codex",
          "exec",
          "review",
          "--base",
          "origin/" .. metadata.baseRefName,
          "--ephemeral",
        }, { cwd = repository_dir }, function(review_result)
          cleanup()
          set_review_result(buffer, review_result)
        end)
      end)
    end)
  end)
end

function M.review(target)
  local lens = review_lenses[target]
  if lens then
    review_lens(target, lens)
    return
  end

  local pull_request = parse_pull_request_url(target)
  if pull_request then
    review_pull_request(target, pull_request)
    return
  end

  vim.notify(
    ("Expected a review lens (%s) or a GitHub pull request URL."):format(
      table.concat(M.complete(""), ", ")
    ),
    vim.log.levels.ERROR
  )
end

return M
