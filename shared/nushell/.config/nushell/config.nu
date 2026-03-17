$env.config = ($env.config
  | upsert show_banner false
  | upsert edit_mode vi
  | upsert buffer_editor "nvim"
)

def create-left-prompt [] {
  let dir = ($env.PWD | path basename)
  let branch = (do -i { ^git branch --show-current } | complete | get stdout | str trim)

  if ($branch | is-empty) {
    $dir
  } else {
    [$dir " (" $branch ")"] | str join
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
