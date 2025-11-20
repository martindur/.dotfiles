linux:
	stow --verbose --restow zsh vim nvim bin wezterm i3 zed yazi

nix:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch

nix-upgrade:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch --upgrade

osx:
	stow --verbose --restow wezterm zsh homebrew nvim vim bin aerospace zed yazi sketchybar

delete:
	stow --verbose --delete */
