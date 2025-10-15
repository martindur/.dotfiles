#!/usr/bin/env bash

set -e

echo "Installing packages via pacman..."

# Ensure git and stow are installed first (needed for dotfiles)
sudo pacman -S --needed --noconfirm git stow

# Update system
sudo pacman -Syu --noconfirm

# Install base development tools
sudo pacman -S --needed --noconfirm base-devel make

# Install X11
sudo pacman -S --needed --noconfirm xorg-server xorg-xinit

# Install display manager
sudo pacman -S --needed --noconfirm lightdm lightdm-slick-greeter

# Install i3 window manager
sudo pacman -S --needed --noconfirm i3-wm i3status i3lock

# Install applications
sudo pacman -S --needed --noconfirm wezterm neovim firefox

# Install CLI tools
sudo pacman -S --needed --noconfirm ripgrep fzf fd bat xclip rofi

# Install Intel graphics drivers
sudo pacman -S --needed --noconfirm mesa intel-media-driver vulkan-intel

echo "All packages installed successfully!"
