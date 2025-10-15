#!/usr/bin/env bash

set -e

echo "=========================================="
echo "  Arch Linux Post-Install Setup"
echo "=========================================="
echo ""

# Check if not running as root
if [ "$EUID" -eq 0 ]; then
    echo "ERROR: Do not run this script as root!"
    echo "The script will use sudo when needed."
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Step 1/4: Installing packages..."
bash "$SCRIPT_DIR/packages.sh"

echo ""
echo "Step 2/4: Setting up AUR helper (yay)..."
bash "$SCRIPT_DIR/aur.sh"

echo ""
echo "Step 3/4: Configuring system services..."
sudo bash "$SCRIPT_DIR/configure.sh"

echo ""
echo "Step 4/4: Stowing dotfiles..."
bash "$SCRIPT_DIR/stow.sh"

echo ""
echo "=========================================="
echo "  Installation Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Reboot your system: sudo reboot"
echo "2. Log in through lightdm"
echo "3. i3 will start automatically"
echo ""
echo "Enjoy your new Arch Linux setup!"
