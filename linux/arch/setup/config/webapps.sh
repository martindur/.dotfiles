#!/usr/bin/env bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BIN_DIR="$DOTFILES_DIR/bin/usr/local/bin"

# Source logging helper
source "$SCRIPT_DIR/../helpers/logging.sh"

log "Installing pre-configured webapps..."

# Ensure webapp scripts are executable
chmod +x "$BIN_DIR/webapp-install"
chmod +x "$BIN_DIR/webapp-launch"
chmod +x "$BIN_DIR/webapp-remove"

# Create icons directory
mkdir -p "$HOME/.local/share/applications/icons"

# Install ChatGPT
log "Installing ChatGPT webapp..."
"$BIN_DIR/webapp-install" "ChatGPT" "https://chatgpt.com/" "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/chatgpt.png"

# Install Discord
log "Installing Discord webapp..."
"$BIN_DIR/webapp-install" "Discord" "https://discord.com/channels/@me" "https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/png/discord.png"

echo ""
log_info "Webapps installed successfully!"
echo ""
echo "You can now launch these apps via Rofi:"
echo "  - ChatGPT"
echo "  - Discord"
echo ""
echo "To install more webapps, run: webapp-install"
echo "To remove webapps, run: webapp-remove"
