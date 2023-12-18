
# function fish_greeting
#     git-tip | ponysay
# end

set fish_greeting         # Remove default greeting
#set TERM "alacritty"		# Sets the terminal type
set EDITOR "nvim"		# $EDITOR use neovim in terminal
#alias vim="nvim"
#alias vi="nvim"
alias n="nvim"

# VIMmy terminal
fish_vi_key_bindings

if status is-interactive
    # Commands to run in interactive sessions can go here
end

pyenv init - | source

# PATHs #
fish_add_path ~/go/bin
fish_add_path ~/.config/bin
fish_add_path ~/.local/bin

fish_add_path ~/.ebcli-virtual-env/executables

set DOTFILES ~/.dotfiles
if test -z $PROJECT_CONTEXT
    set PROJECT_CONTEXT "$HOME/work"
end

# Docker
alias d="docker"
alias dc="docker compose"

# ASDF completions
# source /opt/asdf-vm/asdf.fish

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

function lazy-postgres
  docker stop lazy-postgres &> /dev/null
  docker run --name lazy-postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -v $PWD/postgres:/var/lib/postgresql/data -d --rm postgres:16
end

alias gp="find $HOME -type f -not -name '.*' | fzf | sed 's/^..//' | tr -d '\n' | xclip -selection clipboard"
