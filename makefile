STOW = stow --target=$(HOME)

.PHONY: install delete laptop nix nix-upgrade

install:
	$(STOW) --verbose --restow home

delete:
	$(STOW) --verbose --delete home

laptop:
	sudo install -Dm644 touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf

nix:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch

nix-upgrade:
	sudo nixos-rebuild -I nixos-config=./configuration.nix switch --upgrade
