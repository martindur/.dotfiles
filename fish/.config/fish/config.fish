
# function fish_greeting
#     git-tip | ponysay
# end

set fish_greeting         # Remove default greeting
#set TERM "alacritty"		# Sets the terminal type
set EDITOR "nvim"		# $EDITOR use neovim in terminal
alias vim="nvim"
alias vi="nvim"
alias n="nvim"

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
if test -z $PROJECT_CONTEXT
    set PROJECT_CONTEXT "$HOME/work"
end

# Docker
alias d="docker"
alias dc="docker-compose"

# Kubernetes
set USE_GKE_GCLOUD_AUTH_PLUGIN "True"

# p
alias p="~/code/projects/p/p"

function context
    if test $argv[1] = "p"
        set PROJECT_CONTEXT "$HOME/personal"
        echo "Context set to personal" | cowsay
    else if test $argv[1] = "w"
        set PROJECT_CONTEXT "$HOME/work"
        echo "Context set to work" | cowsay
    else
        echo "Invalid context"
    end
    echo "Location: $PROJECT_CONTEXT"
end

# Poetry keyring issue?
set PYTHON_KEYRING_BACKEND "keyring.backends.null.Keyring"

# Key bindings (Duplicates might appear to have bindings in both insert/normal mode)

# This is equivalent to Right Alt+f (Fish is pretty much ignoring my Left Alt)
# bind \u0111 'tmux-sessionizer'
# bind -M insert \u0111 'tmux-sessionizer'
