
# function fish_greeting
#     git-tip | ponysay
# end

set fish_greeting         # Remove default greeting
#set TERM "alacritty"		# Sets the terminal type
set EDITOR "nvim"		# $EDITOR use neovim in terminal
alias vim="nvim"
alias vi="nvim"

# VIMmy terminal
fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# PATHs #

fish_add_path ~/go/bin
fish_add_path ~/.config/bin
fish_add_path ~/.local/bin

set DOTFILES ~/.dotfiles

# Iconfinder
alias nf="cd ~/code/projects/iconfinder/nextfinder && nvim"

# Docker
alias d="docker"
alias dc="docker-compose"

# Kubernetes
set USE_GKE_GCLOUD_AUTH_PLUGIN "True"

# p
alias p="~/code/projects/p/p"


# New durwiki file
function durwiki
    read wikifile
    touch "$HOME/durwiki/$wikifile.md"
end

# Dotfile management
alias dot="cd ~/.dotfiles && nvim"


# Poetry keyring issue?
set PYTHON_KEYRING_BACKEND "keyring.backends.null.Keyring"

# Key bindings (Duplicates might appear to have bindings in both insert/normal mode)

# This is equivalent to Right Alt+f (Fish is pretty much ignoring my Left Alt)
# bind \u0111 'tmux-sessionizer'
# bind -M insert \u0111 'tmux-sessionizer'
