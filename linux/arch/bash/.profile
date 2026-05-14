# ~/.profile

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

if [ -z "${DISPLAY:-}" ] && [ "${XDG_VTNR:-}" = 1 ]; then
  exec startx
fi
