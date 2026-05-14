# ~/.bashrc

[[ $- != *i* ]] && return

export EDITOR="nvim"
export TERM="xterm-256color"
export BAT_THEME="kanagawa"

path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.config/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.bun/bin"
path_prepend "$HOME/.local/share/mise/shims"

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
shopt -s checkwinsize

alias ll="ls -la"
alias g="git"
alias v="nvim"

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

PS1='\w \$ '
