STOW = stow --target=$(HOME)
ROOT_STOW = sudo stow --target=/
SHARED = agents bash vim nvim wezterm mise
LINUX = i3 rofi
ARCH_HOME = bash
ARCH_ROOT = bin xorg

.PHONY: linux linux-arch nix nix-upgrade osx delete

linux:
	$(STOW) --dir=shared --verbose --restow $(SHARED)
	$(STOW) --dir=linux --verbose --restow $(LINUX)

linux-arch: linux
	$(STOW) --dir=linux/arch --verbose --restow $(ARCH_HOME)
	$(ROOT_STOW) --dir=linux/arch --verbose --restow $(ARCH_ROOT)

nix:
	sudo nixos-rebuild -I nixos-config=./linux/configuration.nix switch

nix-upgrade:
	sudo nixos-rebuild -I nixos-config=./linux/configuration.nix switch --upgrade

osx:
	$(STOW) --dir=shared --verbose --restow $(SHARED)
	$(STOW) --dir=osx --verbose --restow aerospace sketchybar bash

delete:
	$(STOW) --dir=osx --verbose --delete aerospace sketchybar bash || true
	$(ROOT_STOW) --dir=linux/arch --verbose --delete $(ARCH_ROOT) || true
	$(STOW) --dir=linux/arch --verbose --delete $(ARCH_HOME) || true
	$(STOW) --dir=linux --verbose --delete $(LINUX) || true
	$(STOW) --dir=shared --verbose --delete $(SHARED)
