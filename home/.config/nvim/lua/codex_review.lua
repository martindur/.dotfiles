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
}

local function set_buffer_content(buffer, lines)
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end

  vim.bo[buffer].modifiable = true
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].modifiable = false
end

local function set_status(buffer, lens_name, message)
  set_buffer_content(buffer, {
    ("# Codex Review: %s"):format(lens_name),
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

local function create_review_buffer(lens_name)
  vim.cmd.tabnew()

  local buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(
    buffer,
    ("codex-review://%s/%d"):format(lens_name, buffer)
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

local function check_dependencies()
  local missing = {}

  for _, command in ipairs({ "codex", "git" }) do
    if vim.fn.executable(command) == 0 then
      table.insert(missing, command)
    end
  end

  return missing
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

function M.review(lens_name)
  local lens = review_lenses[lens_name]
  if not lens then
    local available = M.complete("")
    vim.notify(
      ("Unknown review lens %q. Available lenses: %s"):format(
        lens_name,
        table.concat(available, ", ")
      ),
      vim.log.levels.ERROR
    )
    return
  end

  local missing = check_dependencies()
  if #missing > 0 then
    vim.notify(
      "CodexReview requires these commands: " .. table.concat(missing, ", "),
      vim.log.levels.ERROR
    )
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
      if review_result.code ~= 0 then
        set_buffer_content(buffer, command_error("running Codex", review_result))
        return
      end

      local review = vim.trim(review_result.stdout or "")
      if review == "" then
        review = "Codex completed without returning a review."
      end

      set_buffer_content(buffer, vim.split(review, "\n", { plain = true }))
    end)
  end)
end

return M
