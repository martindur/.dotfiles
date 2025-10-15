#!/usr/bin/env bash

set -e

echo "Installing yay (AUR helper)..."

# Check if yay is already installed
if command -v yay &> /dev/null; then
    echo "yay is already installed, skipping..."
    exit 0
fi

# Create temporary directory for building yay
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Clone yay repository
git clone https://aur.archlinux.org/yay.git

# Build and install yay
cd yay
makepkg -si --noconfirm

# Clean up
cd ~
rm -rf "$TMP_DIR"

echo "yay installed successfully!"
