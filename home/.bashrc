# ~/.bashrc

[[ $- != *i* ]] && return

export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME="ansi"

CDPATH=.:$HOME/projects:$HOME

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
