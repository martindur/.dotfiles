#!/usr/bin/env bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$SCRIPT_DIR"

# Source logging helper
source "$SCRIPT_DIR/../helpers/logging.sh"

log_section "Installing packages"

# Update system first
log "Updating system..."
sudo pacman -Syu --noconfirm

# Install base packages
log "Installing base packages from base.packages..."
mapfile -t packages < <(grep -v '^#' "$PACKAGES_DIR/base.packages" | grep -v '^$')

if [ ${#packages[@]} -gt 0 ]; then
  sudo pacman -S --needed --noconfirm "${packages[@]}"
  log_info "Base packages installed successfully"
else
  log_warn "No base packages found to install"
fi

# Install AUR packages if any are listed
log "Checking for AUR packages..."
mapfile -t aur_packages < <(grep -v '^#' "$PACKAGES_DIR/aur.packages" | grep -v '^$')

if [ ${#aur_packages[@]} -gt 0 ]; then
  # Check if yay is installed
  if command -v yay &> /dev/null; then
    log "Installing AUR packages from aur.packages..."
    yay -S --needed --noconfirm "${aur_packages[@]}"
    log_info "AUR packages installed successfully"
  else
    log_warn "yay not found. Skipping AUR packages. Run aur.sh first if needed."
  fi
else
  log "No AUR packages to install"
fi

log_info "All packages installed successfully!"
