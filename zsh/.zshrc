PATH="$HOME/.config/bin:$PATH" # all my custom runnable scripts
PATH="$HOME/.cargo/bin:$PATH" # binaries built with rust

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm

# Syncs homebrew with packages from brewfile
alias bsync="brew update && \
    brew bundle install --cleanup --file=~/.config/brewfile --no-lock && \
    brew upgrade"

# OSX
if [[ $(uname) == 'Darwin' ]]; then
# Syntax highlighting
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  # pyenv
  PYENV_ROOT="$HOME/.pyenv"
  PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

if [[ $(uname) == 'Linux' ]]; then
  alias nvim='steam-run nvim' # a NixOS 'hack' to run binaries not installed via nix packages. Without this, Mason can't download and run LSPs
  alias n='steam-run nvim'
fi

# Runs a postgres container and maps the data volume to the given project folders directory
# An easy way to run postgres in a minimal way, without relying on compose or other custom code
lazy-postgres () {
  docker stop lazy-postgres &> /dev/null
  docker run --name lazy-postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -v $PWD/postgres:/var/lib/postgresql/data -d --rm postgres:16
}
