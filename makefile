SHARED = zsh vim nvim bin wezterm yazi

linux:
	stow --verbose --restow $(SHARED) i3

nix:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch

nix-upgrade:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch --upgrade

mac:
	stow --verbose --restow $(SHARED) aerospace sketchybar

osx: mac

delete:
	stow --verbose --delete */
