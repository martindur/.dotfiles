
# function fish_greeting
#     git-tip | ponysay
# end

#set TERM "alacritty"		# Sets the terminal type
set EDITOR "helix"		# $EDITOR use neovim in terminal
alias vim="nvim"
alias hx="helix"

# VIMmy terminal
fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# PATHs #

fish_add_path ~/go/bin
fish_add_path ~/.config/bin

set DOTFILES ~/.dotfiles

# Iconfinder
alias nf="cd ~/code/projects/iconfinder/nextfinder && helix"

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
alias dot="cd ~/.dotfiles && helix"


# Key bindings (Duplicates might appear to have bindings in both insert/normal mode)

# This is equivalent to Right Alt+f (Fish is pretty much ignoring my Left Alt)
bind \u0111 'tmux-sessionizer'
bind -M insert \u0111 'tmux-sessionizer'
