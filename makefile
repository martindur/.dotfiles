linux:
	stow --verbose --restow x fish qtile picom nvim bin p tmux kitty helix mprocs
osx:
	stow --verbose --restow nvim sketchybar fish bin p tmux kitty helix
delete:
	stow --verbose --delete */
