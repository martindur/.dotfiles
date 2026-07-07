# ~/.bashrc

[[ $- != *i* ]] && return

export EDITOR="nvim"
export VISUAL="nvim"
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

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

git_branch() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local branch
  branch=$(git branch --show-current 2>/dev/null)
  [ -n "$branch" ] && printf " (%s)" "$branch"
}

PS1='\[\e[34m\]\w\[\e[36m\]$(git_branch)\[\e[0m\] \$ '
