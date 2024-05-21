bootstrap:
	./scripts/bootstrap.sh

linux:
	stow --verbose --restow zsh vim nvim bin wezterm i3

linux-wsl:
	stow --verbose --restow zsh vim nvim bin wezterm

nix:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch

nix-upgrade:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch --upgrade

nix-wsl:
	sudo nixos-rebuild -I nixos-config=./configuration-wsl.nix switch

osx:
	stow --verbose --restow wezterm yabai zsh skhd homebrew nvim vim bin

delete:
	stow --verbose --delete */
