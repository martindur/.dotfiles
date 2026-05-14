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

# Source logging helper
source "$SCRIPT_DIR/helpers/logging.sh"

# Initialize log
init_log

log_section "Starting Arch Linux Post-Install Setup"

# Step 1: Install packages
log_section "Step 1/5: Installing packages"
bash "$SCRIPT_DIR/packages/install.sh"

# Step 2: Set up AUR helper (yay)
log_section "Step 2/5: Setting up AUR helper (yay)"
bash "$SCRIPT_DIR/config/aur.sh"

# Step 3: Configure system services
log_section "Step 3/4: Configuring system services"
sudo bash "$SCRIPT_DIR/config/network.sh"

# Step 4: Install webapps
log_section "Step 4/5: Installing webapps"
bash "$SCRIPT_DIR/config/webapps.sh"

# Step 5: Stow dotfiles (includes bin scripts to /usr/local/bin)
log_section "Step 5/5: Stowing dotfiles"
bash "$SCRIPT_DIR/config/stow.sh"

# Finish log
finish_log

echo ""
log_section "Installation Complete!"
echo ""
log_info "Next steps:"
echo "  1. Reboot your system: sudo reboot"
echo "  2. Log in through lightdm"
echo "  3. i3 will start automatically"
echo ""
log_info "Helper scripts available in /usr/local/bin:"
echo "  - webapp-install       : Install a new webapp"
echo "  - webapp-remove        : Remove a webapp"
echo "  - restart-bluetooth    : Restart bluetooth service"
echo "  - restart-audio        : Restart audio services"
echo "  - restart-network      : Restart network service"
echo ""
log_info "Optional configuration scripts in linux/arch/setup/config/:"
echo "  - bluetooth.sh  : Setup bluetooth"
echo "  - audio.sh      : Setup audio (PipeWire)"
echo "  - touchpad.sh   : Setup touchpad"
echo "  - firewall.sh   : Setup UFW firewall"
echo "  - tailscale.sh  : Setup Tailscale VPN"
echo ""
log_info "Installation log saved to: $INSTALL_LOG_FILE"
echo ""
echo "Enjoy your new Arch Linux setup!"
