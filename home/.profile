# ~/.profile

export BASH_SILENCE_DEPRECATION_WARNING=1

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

if [ -z "${DISPLAY:-}" ] &&
  [ "${XDG_VTNR:-}" = 1 ] &&
  command -v startx >/dev/null 2>&1; then
  exec startx
fi
