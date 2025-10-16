# Arch Linux Post-Install Setup

Quick setup scripts to get your system configured after installing Arch Linux with `archinstall`.

## Prerequisites

- Fresh Arch Linux installation (using `archinstall`)
- Internet connection
- User account with sudo privileges

## What Gets Installed

- **Display Manager:** lightdm with slick greeter
- **Window Manager:** i3
- **Terminal:** wezterm
- **Editor:** neovim
- **Browser:** firefox
- **CLI Tools:** git, stow, ripgrep, fzf, fd, bat, xclip, rofi
- **AUR Helper:** yay
- **Intel Graphics:** mesa, intel-media-driver, vulkan-intel

## Installation

### If git is NOT installed:

```bash
sudo pacman -S git
git clone <your-dotfiles-repo-url> ~/.dotfiles
cd ~/.dotfiles/arch-setup
./install.sh
```

### If git IS installed (selected during archinstall):

```bash
git clone <your-dotfiles-repo-url> ~/.dotfiles
cd ~/.dotfiles/arch-setup
./install.sh
```

## What Happens

1. Installs all packages via pacman
2. Sets up yay (AUR helper)
3. Configures lightdm and system services
4. Stows your dotfiles (bash, vim, nvim, bin, i3, yazi)

## After Installation

Reboot your system:

```bash
sudo reboot
```

You'll be greeted by lightdm and can log into your i3 session.

## Optional Setup Scripts

Run these as needed for additional hardware/features:

```bash
# Bluetooth support
./bluetooth.sh

# Audio support (PipeWire)
./audio.sh

# NetworkManager (if not already configured)
./network.sh

# Touchpad support (for laptops)
./touchpad.sh

# Firewall (UFW - deny all incoming, allow tailscale)
./firewall.sh

# Tailscale VPN
./tailscale.sh
```

## Manual Steps

If you need to re-stow configs later:

```bash
cd ~/.dotfiles
make linux
```
