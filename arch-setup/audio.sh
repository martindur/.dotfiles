#!/usr/bin/env bash

set -e

echo "Setting up audio with PipeWire..."

# Install PipeWire and related packages
sudo pacman -S --needed --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Enable PipeWire service for user
systemctl --user enable pipewire.service
systemctl --user enable pipewire-pulse.service
systemctl --user enable wireplumber.service

echo "Audio setup complete!"
echo "PipeWire will start automatically on next login"
echo "You can start it now with: systemctl --user start pipewire pipewire-pulse wireplumber"
