bootstrap:
	./scripts/bootstrap.sh

linux:
	stow --verbose --restow x fish qtile picom nvim bin p tmux kitty mprocs wezterm

nix:
	stow --verbose --restow nvim wezterm

osx:
	stow --verbose --restow helix wezterm yabai zsh skhd homebrew nvim vim bin

delete:
	stow --verbose --delete */
