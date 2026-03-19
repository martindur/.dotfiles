use std/util "path add"

$env.EDITOR = "nvim"
$env.TERM = "xterm-256color"
$env.BAT_THEME = "kanagawa"

path add "~/.config/bin"
path add "~/.cargo/bin"
path add "~/.bun/bin"
path add "~/.local/share/mise/shims"
path add "~/.local/bin"

if $nu.os-info.name == "macos" {
  path add "/opt/homebrew/bin"
  path add "/opt/homebrew/sbin"
  path add "~/.orbstack/bin"
}
