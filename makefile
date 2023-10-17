linux:
	stow --verbose --restow x fish qtile picom nvim bin p tmux kitty mprocs wezterm

nix:
	stow --verbose --restow nvim wezterm

delete:
	stow --verbose --delete */
