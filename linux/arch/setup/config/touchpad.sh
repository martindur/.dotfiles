#!/usr/bin/env bash

set -e

echo "Setting up touchpad support..."

# Install libinput for touchpad support
sudo pacman -S --needed --noconfirm xf86-input-libinput

# Ensure the target directory exists
sudo mkdir -p /etc/X11/xorg.conf.d

# Remove existing config file if it exists (so stow can create the symlink)
sudo rm -f /etc/X11/xorg.conf.d/30-touchpad.conf

# Use stow to symlink the xorg configuration
# Note: stow needs to be run with sudo to create symlinks in /etc
cd ~/.dotfiles
sudo stow -t / xorg

echo "Touchpad setup complete!"
echo "Touchpad settings:"
echo "  - Tap to click: enabled"
echo "  - Natural scrolling: enabled"
echo "  - Two-finger scrolling: enabled"
echo ""
echo "Restart X11 (logout/login) for changes to take effect"
