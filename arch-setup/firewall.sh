#!/usr/bin/env bash

set -e

echo "Setting up firewall with UFW..."

# Install ufw (Uncomplicated Firewall)
sudo pacman -S --needed --noconfirm ufw

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow Tailscale
# Tailscale uses UDP port 41641 and the tailscale0 interface
sudo ufw allow in on tailscale0

# Enable the firewall
sudo ufw --force enable

# Enable ufw service to start on boot
sudo systemctl enable ufw.service
sudo systemctl start ufw.service

echo "Firewall setup complete!"
echo ""
echo "Firewall rules:"
echo "  - Default: deny all incoming, allow all outgoing"
echo "  - Tailscale: allowed on tailscale0 interface"
echo ""
echo "To check status: sudo ufw status verbose"
echo "To allow specific ports: sudo ufw allow <port>"
echo "To allow specific services: sudo ufw allow <service>"
