#!/usr/bin/env bash

set -e

echo "Setting up touchpad support..."

# Install libinput for touchpad support
sudo pacman -S --needed --noconfirm xf86-input-libinput

# Create libinput configuration for touchpad
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null << 'EOF'
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "ScrollMethod" "twofinger"
EndSection
EOF

echo "Touchpad setup complete!"
echo "Touchpad settings:"
echo "  - Tap to click: enabled"
echo "  - Natural scrolling: enabled"
echo "  - Two-finger scrolling: enabled"
echo ""
echo "Restart X11 (logout/login) for changes to take effect"
