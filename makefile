linux:
	stow --verbose --restow x alacritty fish qtile picom nvim bin p tmux task kitty zellij
osx:
	stow --verbose --restow nvim sketchybar fish bin p tmux kitty
delete:
	stow --verbose --delete */
