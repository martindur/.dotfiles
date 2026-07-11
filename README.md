
# Dotfiles

Personal configuration, managed with GNU Stow.

The repo is split into three package roots:

- `shared/` for tools used on both macOS and Linux
- `osx/` for macOS-only config
- `linux/` for Linux-only config and `configuration.nix`
- `linux/arch/` for Arch-specific setup scripts and system-level helpers

Shell:

- `shared/bash/` is the portable interactive shell config
- `linux/arch/bash/` contains Arch-specific login startup
- `shared/mise/` is the cross-system tool/runtime source of truth

Stow commands target `$HOME` explicitly so the setup stays portable across macOS and Linux.

Useful targets:

- `make osx`
- `make linux`
- `make linux-arch`
- `make nix`
- `make nix-upgrade`

Examples:

- `stow --target="$HOME" --dir=shared alacritty bash nvim mise`
- `stow --target="$HOME" --dir=osx aerospace sketchybar`
- `stow --target="$HOME" --dir=linux i3 rofi`
