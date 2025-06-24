export EDITOR='nvim'
export TERM='xterm-256color'
export BAT_THEME='kanagawa'

# OSX
if [[ $(uname) == 'Darwin' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Added by OrbStack: command-line tools and integration
# Comment this line if you don't want it to be added again.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Created by `pipx` on 2024-09-24 13:45:52
export PATH="$PATH:/Users/dur/.local/bin"
