
#### STYLING ####

source <(antibody init)

export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

antibody bundle robbyrussell/oh-my-zsh
antibody bundle robbyrussell/oh-my-zsh path:plugins/git
antibody bundle robbyrussell/oh-my-zsh path:plugins/git-flow
antibody bundle robbyrussell/oh-my-zsh path:plugins/docker
antibody bundle robbyrussell/oh-my-zsh path:plugins/docker-compose

antibody bundle ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme

# This needs to be the last bundle
antibody bundle zsh-users/zsh-syntax-highlighting


# load theme
ZSH_THEME="gruvbox"
SOLARIZED_THEME="dark"
# antibody bundle dracula/zsh
#### ####

#### CONFIG ####
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d
zstyle ':completion:*:descriptions' format %B%d%b
zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
        'local-directories named-directories'


export GIT_EDITOR=vim
export EDITOR='vim'

#### ALIASES and FUNCTIONS ####

# General
alias vim="nvim"
alias uvim="cd ~/.config/nvim"
alias mux="tmuxinator"

# Git
alias g="git"
alias gs="git status"
alias co="git checkout"
alias gst="git stash"

# Docker
alias d="docker"
alias dc="docker-compose"
alias dce="docker-compose exec"

# Iconfinder
alias nf="cd ~/code/iconfinder/nextfinder && vim"
alias nfshell="docker-compose exec nextfinder ./bin/nextfinder shell"
