#!/usr/bin/env bash

set -e

echo "Setting up Bluetooth..."

# Install bluetooth packages
sudo pacman -S --needed --noconfirm bluez bluez-utils

# Enable and start bluetooth service
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

echo "Bluetooth setup complete!"
echo "Use 'bluetoothctl' to manage bluetooth devices"
