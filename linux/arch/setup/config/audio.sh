#!/usr/bin/env bash

set -e

echo "Setting up audio with PipeWire..."

# Install PipeWire and related packages
echo "Installing PipeWire packages..."

sudo pacman -S --needed --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber sof-firmware

# Verify installation
if ! command -v wpctl &> /dev/null; then
    echo "ERROR: wpctl not found. PipeWire installation may have failed."
    exit 1
fi

echo "PipeWire packages installed successfully."

# Enable and start PipeWire services for user
echo "Enabling and starting PipeWire services..."
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service

# Wait a moment for services to initialize
sleep 2

# Verify services are running
echo ""
echo "Checking service status..."
if systemctl --user is-active --quiet pipewire.service && \
   systemctl --user is-active --quiet wireplumber.service; then
    echo "✓ PipeWire services are running"
else
    echo "⚠ Warning: Some services may not be running properly"
    echo "Run: systemctl --user status pipewire wireplumber"
fi

# Show audio devices
echo ""
echo "Audio devices:"
wpctl status | head -20

echo ""
echo "Audio setup complete!"
echo ""
echo "⚠️  IMPORTANT: You need to REBOOT for the SOF firmware to load properly!"
echo ""
echo "After reboot, useful commands:"
echo "  - Check status: systemctl --user status pipewire wireplumber"
echo "  - List devices: wpctl status"
echo "  - Set volume: wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%"
echo "  - Test audio: speaker-test -c2 -twav"
