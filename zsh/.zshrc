PATH="$HOME/.config/bin:$PATH" # all my custom runnable scripts
PATH="$HOME/.cargo/bin:$PATH" # binaries built with rust
PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH" # postgres utility (psql, pg_dump, etc.)
PATH="$HOME/.bun/bin:$PATH" # bun global packages

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm

# Syncs homebrew with packages from brewfile
alias bsync="brew update && \
    brew bundle install --cleanup --file=~/.config/brewfile --no-lock && \
    brew upgrade"

alias bsyncr="brew update && \
    brew bundle install --cleanup --file=~/.config/reshape.brewfile && \
    brew upgrade"

alias python="python3"


if [[ $(uname) == 'Linux' ]]; then
  # alias nvim='steam-run nvim' # a NixOS 'hack' to run binaries not installed via nix packages. Without this, Mason can't download and run LSPs
  alias n='steam-run nvim'
fi

# Runs a postgres container and maps the data volume to the given project folders directory
# An easy way to run postgres in a minimal way, without relying on compose or other custom code
lazy-postgres () {
  docker stop lazy-postgres &> /dev/null
  docker rm lazy-postgres &> /dev/null
  docker run --name lazy-postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -v $PWD/postgres:/var/lib/postgresql/data -d --rm postgres:16
}

lazy-chroma () {
  docker stop lazy-chroma &> /dev/null
  docker rm lazy-chroma &> /dev/null
  docker run --name lazy-chroma -p 8000:8000 -v $PWD/chroma-data:/data -d --rm chromadb/chroma:0.6.3
}

lazy-video () {
  dir="$HOME/videos/recordings"
  params=$(flameshot gui -g)
  array=(`echo $params | sed 's/+/\n/g'`)
  now=`date "+%F_%H-%M-%S"`
  filename="${dir}/${now}.mp4"
  # ffmpeg -f x11grab -framerate 24 -i :0.0 -select_region 1 -show_region 1 "${filename}"
  ffmpeg -f x11grab -framerate 24 -video_size "${array[1]}" -framerate 24 -i :0.0+"${array[2]}","${array[3]}" "${filename}"
}

# wrapper over yazi to open file (intended to be called from zed task)
function ya_zed() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --chooser-file="$tmp"

	local opened_file=$(cat -- "$tmp" | head -n 1)
	zed -- "$opened_file"

	rm -f -- "$tmp"
	exit
}

function zed_file_search() {
  local FILE
  FILE=$(
    rg --files --hidden --color=always \
      --glob '!**/.git' \
      --glob '!**/node_modules' \
      --glob '!**/.venv' \
    | fzf --ansi --preview 'bat --decorations=always --color=always {} --style=full --line-range :50' \
      --layout=reverse
  )

  if [ -n "$FILE" ]; then
    zed "$FILE"
  fi
}

if [ -f ~/.env ]; then
    export $(grep -v '^#' ~/.env | xargs)
else
    echo ".env file not found"
fi

function zed_open_project() {
  local PROJECT_DIR
  PROJECT_DIR=$(
    fd --type d -d 1 . ~/projects \
    | fzf --layout=reverse
  )

  if [ -n "$PROJECT_DIR" ]; then
    zed "$PROJECT_DIR"
  fi
}

# Created by `pipx` on 2024-09-24 13:45:52
export PATH="$PATH:/Users/dur/.local/bin"

source /Users/dur/.config/broot/launcher/bash/br

eval "$(starship init zsh)"


# OSX
if [[ $(uname) == 'Darwin' ]]; then
  # pyenv
  PYENV_ROOT="$HOME/.pyenv"
  PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

# Syntax highlighting

  # ZSH_HIGHLIGHT_FILE="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  # ZSH_HIGHLIGHT_ZWC="${ZSH_HIGHLIGHT_FILE}.zwc"
  #
  # if [[ ! -f $ZSH_HIGHLIGHT_ZWC || $ZSH_HIGHLIGHT_FILE -nt $ZSH_HIGHLIGHT_ZWC ]]; then
  #   zcompile -q -- "$ZSH_HIGHLIGHT_FILE"
  # fi

  # source "$ZSH_HIGHLIGHT_FILE"

  # source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
