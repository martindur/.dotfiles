
# Dotfiles

Personal configuration, managed with GNU Stow.

The repo is split into three package roots:

- `shared/` for tools used on both macOS and Linux
- `osx/` for macOS-only config
- `linux/` for Linux-only config and `configuration.nix`

Stow commands target `$HOME` explicitly so the setup stays portable across macOS and Linux.

Useful targets:

- `make osx`
- `make linux`
- `make nix`
- `make nix-upgrade`

Examples:

- `stow --target="$HOME" --dir=shared nvim zsh wezterm`
- `stow --target="$HOME" --dir=osx aerospace sketchybar`
- `stow --target="$HOME" --dir=linux i3`
