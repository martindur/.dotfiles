
set fish_greeting		# Supresses fish's intro message
set TERM "alacritty"		# Sets the terminal type
set EDITOR "nvim"		# $EDITOR use neovim in terminal


if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/go/bin

set DOTFILES ~/.dotfiles
