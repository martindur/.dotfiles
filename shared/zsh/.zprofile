export EDITOR='nvim'
export TERM='xterm-256color'
export BAT_THEME='kanagawa'
export PATH="$HOME/.local/bin:$PATH"

# OSX
if [[ $(uname) == 'Darwin' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
