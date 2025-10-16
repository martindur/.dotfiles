#!/usr/bin/env bash

set -e

echo "Setting up NetworkManager..."

# Install NetworkManager
sudo pacman -S --needed --noconfirm networkmanager

# Enable and start NetworkManager service
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

echo "NetworkManager setup complete!"
echo "Use 'nmtui' for a text-based interface or 'nmcli' for command-line control"
