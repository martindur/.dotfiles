# ~/.profile

export BASH_SILENCE_DEPRECATION_WARNING=1

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
