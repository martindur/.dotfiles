# zmodload zsh/zprof

PATH="$HOME/.config/bin:$PATH" # all my custom runnable scripts
PATH="$HOME/.cargo/bin:$PATH" # binaries built with rust
PATH="$HOME/.bun/bin:$PATH" # bun global packages
PATH="$HOME/.local/share/mise/shims:$PATH" # project tool shims

alias python="python3"


if [[ $(uname) == 'Linux' ]]; then
  # alias nvim='steam-run nvim' # a NixOS 'hack' to run binaries not installed via nix packages. Without this, Mason can't download and run LSPs
  alias n='steam-run nvim'
fi

if [[ "$OSTYPE" == darwin* ]]; then
  PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH" # postgres utility (psql, pg_dump, etc.)
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


# Start Dozzle with static name and port; no-op if already running or name conflicts.
dozzle() {
  docker start dozzle >/dev/null 2>&1 || \
  docker run -d --name dozzle -p 8888:8080 -v /var/run/docker.sock:/var/run/docker.sock amir20/dozzle:latest >/dev/null 2>&1
}

export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"


# OSX
if [[ "$OSTYPE" == darwin* ]]; then
  # Syntax highlighting
  if [ -n "${HOMEBREW_PREFIX:-}" ]; then
    if [ -r "${HOMEBREW_PREFIX}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
      source "${HOMEBREW_PREFIX}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
    fi
    if [ -r "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
      source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi
  fi
fi

# zprof

# bun completions
[ -s "/Users/dur/.bun/_bun" ] && source "/Users/dur/.bun/_bun"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
