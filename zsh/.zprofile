export EDITOR='nvim'
export TERM='wezterm'

# OSX
if [[ $(uname) == 'Darwin' ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
