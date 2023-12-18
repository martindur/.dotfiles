bootstrap:
	./scripts/bootstrap.sh

linux:
	stow --verbose --restow x fish qtile picom nvim vim bin wezterm

nix:
	stow --verbose --restow nvim wezterm

osx:
	stow --verbose --restow wezterm yabai zsh skhd homebrew nvim vim bin

delete:
	stow --verbose --delete */
