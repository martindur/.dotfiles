STOW = stow --target=$(HOME)

.PHONY: install delete nix nix-upgrade

install:
	$(STOW) --verbose --restow home

delete:
	$(STOW) --verbose --delete home

nix:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch

nix-upgrade:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch --upgrade
