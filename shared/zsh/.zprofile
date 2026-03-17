export EDITOR='nvim'
export TERM='xterm-256color'
export BAT_THEME='kanagawa'
export PATH="$HOME/.local/bin:$PATH"

# OSX
if [[ $(uname) == 'Darwin' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # Added by OrbStack: command-line tools and integration
  # Comment this line if you don't want it to be added again.
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi
