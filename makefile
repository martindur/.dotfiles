STOW = stow --target=$(HOME)
ROOT_STOW = sudo stow --target=/
SHARED = zsh vim nvim wezterm nushell mise
LINUX = i3 rofi bash
ARCH = bin xorg

.PHONY: linux linux-arch nix nix-upgrade osx delete

linux:
	$(STOW) --dir=shared --verbose --restow $(SHARED)
	$(STOW) --dir=linux --verbose --restow $(LINUX)

linux-arch: linux
	$(ROOT_STOW) --dir=linux/arch --verbose --restow $(ARCH)

nix:
	sudo nixos-rebuild -I nixos-config=./linux/configuration.nix switch

nix-upgrade:
	sudo nixos-rebuild -I nixos-config=./linux/configuration.nix switch --upgrade

osx:
	$(STOW) --dir=shared --verbose --restow $(SHARED)
	$(STOW) --dir=osx --verbose --restow aerospace sketchybar

delete:
	$(STOW) --dir=osx --verbose --delete aerospace sketchybar || true
	$(ROOT_STOW) --dir=linux/arch --verbose --delete $(ARCH) || true
	$(STOW) --dir=linux --verbose --delete $(LINUX) || true
	$(STOW) --dir=shared --verbose --delete $(SHARED)
