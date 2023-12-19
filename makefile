bootstrap:
	./scripts/bootstrap.sh

linux:
	stow --verbose --restow vim bin wezterm i3

nix:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch

osx:
	stow --verbose --restow wezterm yabai zsh skhd homebrew nvim vim bin

delete:
	stow --verbose --delete */
