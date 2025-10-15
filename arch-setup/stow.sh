#!/usr/bin/env bash

set -e

echo "Stowing dotfiles..."

# Get the dotfiles directory (parent of arch-setup)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Change to dotfiles directory
cd "$DOTFILES_DIR"

# Stow configurations
stow --verbose --restow bash vim nvim bin i3 yazi

echo "Dotfiles stowed successfully!"
