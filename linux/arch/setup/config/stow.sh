#!/usr/bin/env bash

set -e

echo "Stowing dotfiles..."

# Get the dotfiles directory (repo root; this file lives in linux/arch/setup/config/)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"

# Change to dotfiles directory
cd "$DOTFILES_DIR"

# Stow shared, Linux-wide, and Arch-specific configurations
make linux-arch

echo "Dotfiles stowed successfully!"
