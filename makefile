linux:
	stow --verbose --restow x alacritty fish qtile picom nvim bin p helix tmux lvim
osx:
	stow --verbose --restow nvim sketchybar fish bin p tmux lvim
delete:
	stow --verbose --delete */
