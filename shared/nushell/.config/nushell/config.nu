$env.config = ($env.config
  | upsert show_banner false
  | upsert edit_mode vi
  | upsert buffer_editor "nvim"
  | upsert history {
      file_format: sqlite
      max_size: 1_000_000
      sync_on_enter: true
      isolation: true
    }
)

# Nushell 0.111.0 does not support history.path yet.
# When 0.112+ is available, move history to XDG state instead of leaving it
# under the active config directory.

def create-left-prompt [] {
  let dir = ($env.PWD | path basename)
  let branch = (do -i { ^git branch --show-current } | complete | get stdout | str trim)

  if ($branch | is-empty) {
    $dir
  } else {
    [$dir " " (ansi dark_gray) "(" (ansi cyan) $branch (ansi dark_gray) ")" (ansi reset)] | str join
  }
}

$env.PROMPT_COMMAND = {||
  create-left-prompt
}

$env.PROMPT_COMMAND_RIGHT = {||
  null
}

$env.PROMPT_INDICATOR = "> "
$env.PROMPT_INDICATOR_VI_INSERT = "> "
$env.PROMPT_INDICATOR_VI_NORMAL = ": "
$env.PROMPT_MULTILINE_INDICATOR = "::: "

alias v = nvim
alias ll = ls -la
alias g = git
