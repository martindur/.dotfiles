STOW = stow --target=$(HOME)
SHARED = zsh vim nvim bin wezterm nushell

.PHONY: linux nix nix-upgrade osx delete

linux:
	$(STOW) --dir=shared --verbose --restow $(SHARED)
	$(STOW) --dir=linux --verbose --restow i3

nix:
	sudo nixos-rebuild -I nixos-config=./linux/configuration.nix switch

nix-upgrade:
	sudo nixos-rebuild -I nixos-config=./linux/configuration.nix switch --upgrade

osx:
	$(STOW) --dir=shared --verbose --restow $(SHARED)
	$(STOW) --dir=osx --verbose --restow aerospace sketchybar

delete:
	$(STOW) --dir=osx --verbose --delete aerospace sketchybar || true
	$(STOW) --dir=linux --verbose --delete i3 || true
	$(STOW) --dir=shared --verbose --delete $(SHARED)
