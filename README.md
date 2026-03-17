
# Dotfiles

Personal configuration, managed with GNU Stow.

Shared tools live at the repo root and are intended to work on both macOS and Linux.
OS-specific config is kept separate:

- `aerospace/` and `sketchybar/` are macOS-only
- `i3/` is Linux-only
- `configuration.nix` is the only package/system declaration that remains

Useful targets:

- `make mac`
- `make linux`
- `make nix`
- `make nix-upgrade`
