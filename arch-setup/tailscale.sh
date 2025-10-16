#!/usr/bin/env bash

set -e

echo "Setting up Tailscale..."

# Install Tailscale
sudo pacman -S --needed --noconfirm tailscale

# Enable and start tailscale service
sudo systemctl enable tailscaled.service
sudo systemctl start tailscaled.service

echo "Tailscale installed successfully!"
echo ""
echo "To connect to your tailnet, run:"
echo "  sudo tailscale up"
echo ""
echo "To check status:"
echo "  tailscale status"
echo ""
echo "To get your tailscale IP:"
echo "  tailscale ip"
