STOW = stow --target=$(HOME)

.PHONY: install delete laptop greetd

install:
	$(STOW) --verbose --restow home

delete:
	$(STOW) --verbose --delete home

laptop:
	sudo pacman -S --needed earlyoom ttf-cascadia-code-nerd
	sudo install -Dm644 earlyoom.conf /etc/default/earlyoom
	sudo systemctl enable earlyoom
	sudo systemctl restart earlyoom

greetd:
	sudo install -Dm644 greetd.conf /etc/greetd/config.toml
	sudo systemctl enable greetd.service
