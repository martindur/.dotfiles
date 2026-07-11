# ~/.profile

export BASH_SILENCE_DEPRECATION_WARNING=1

path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

for directory in \
  "/opt/homebrew/sbin" \
  "/opt/homebrew/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.config/bin" \
  "$HOME/.local/bin" \
  "$HOME/.local/share/mise/shims"; do
  [ -d "$directory" ] && path_prepend "$directory"
done
unset directory

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

if [ -z "${DISPLAY:-}" ] &&
  [ "${XDG_VTNR:-}" = 1 ] &&
  command -v startx >/dev/null 2>&1; then
  exec startx
fi
