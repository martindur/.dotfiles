
# Dotfiles

Personal configuration, managed with GNU Stow.

The repo is split into three package roots:

- `shared/` for tools used on both macOS and Linux
- `osx/` for macOS-only config
- `linux/` for Linux-only config and `configuration.nix`
- `linux/arch/` for Arch-specific setup scripts and system-level helpers

Shells:

- `shared/zsh/` is the minimal compatibility shell config
- `shared/nushell/` is the primary interactive shell config
- `shared/mise/` is the cross-system tool/runtime source of truth
- to make Nushell the macOS login shell, `nu` must be present in `/etc/shells` and then selected with `chsh -s "$(command -v nu)"`

Stow commands target `$HOME` explicitly so the setup stays portable across macOS and Linux.

Useful targets:

- `make osx`
- `make linux`
- `make linux-arch`
- `make nix`
- `make nix-upgrade`

Examples:

- `stow --target="$HOME" --dir=shared nvim zsh wezterm nushell mise`
- `stow --target="$HOME" --dir=osx aerospace sketchybar`
- `stow --target="$HOME" --dir=linux i3 rofi bash`
