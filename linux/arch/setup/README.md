# Arch Linux Post-Install Setup

Quick setup scripts to get your system configured after installing Arch Linux with `archinstall`.

## Prerequisites

- Fresh Arch Linux installation (using `archinstall`)
- Internet connection
- User account with sudo privileges

## What Gets Installed

### Core System
- **Display Manager:** lightdm with slick greeter
- **Window Manager:** i3
- **Terminal:** wezterm
- **Editor:** neovim
- **Browsers:** Firefox (main), Chromium (for webapps)

### CLI Tools
- git, stow, ripgrep, fzf, fd, bat, xclip, rofi, tree, htop, gum

### Webapps
- ChatGPT
- Discord

### AUR Helper
- yay

### Intel Graphics
- mesa, intel-media-driver, vulkan-intel

## Project Structure

```
linux/arch/setup/
├── install.sh              # Main installation script
├── README.md
├── packages/
│   ├── base.packages       # Declarative package list
│   ├── aur.packages        # AUR packages list
│   └── install.sh          # Package installation script
├── config/
│   ├── aur.sh             # Setup yay AUR helper
│   ├── network.sh         # NetworkManager setup
│   ├── stow.sh            # Stow dotfiles
│   ├── webapps.sh         # Install webapps
│   ├── audio.sh           # Optional: Audio (PipeWire)
│   ├── bluetooth.sh       # Optional: Bluetooth
│   ├── touchpad.sh        # Optional: Touchpad
│   ├── firewall.sh        # Optional: UFW firewall
│   └── tailscale.sh       # Optional: Tailscale VPN
├── bin/
│   ├── webapp-install     # Install webapps interactively
│   ├── webapp-launch      # Launch webapp in Chromium
│   ├── webapp-remove      # Remove webapps
│   ├── restart-bluetooth  # Restart bluetooth service
│   ├── restart-audio      # Restart audio services
│   └── restart-network    # Restart network service
└── helpers/
    └── logging.sh         # Logging utilities
```

## Installation

### Quick Start

```bash
# Clone your dotfiles
git clone <your-dotfiles-repo-url> ~/.dotfiles
cd ~/.dotfiles/linux/arch/setup

# Run the installer
./install.sh
```

### What Happens

1. **Packages** - Installs all packages from `packages/base.packages`
2. **AUR Helper** - Sets up yay for AUR packages
3. **System Services** - Configures NetworkManager
4. **Helper Scripts** - Installs utility scripts to `~/.local/bin`
5. **Webapps** - Installs ChatGPT and Discord as webapps
6. **Dotfiles** - Stows your dotfiles (bash, vim, nvim, bin, i3, yazi)

## After Installation

Reboot your system:

```bash
sudo reboot
```

You'll be greeted by lightdm and can log into your i3 session.

## Managing Packages

### Adding New Packages

Edit the package lists:

```bash
# For official packages
vim linux/arch/setup/packages/base.packages

# For AUR packages
vim linux/arch/setup/packages/aur.packages

# Then reinstall
cd ~/.dotfiles/linux/arch/setup
./packages/install.sh
```

### Package File Format

- One package per line
- Comments start with `#`
- Empty lines are ignored

Example:
```
# My favorite tools
neovim
firefox
htop

# Development
git
base-devel
```

## Helper Scripts

After installation, these scripts are available in your PATH:

### Webapp Management
```bash
# Install a new webapp interactively
webapp-install

# Install a webapp with arguments
webapp-install "GitHub" "https://github.com" "https://path/to/icon.png"

# Remove a webapp (interactive)
webapp-remove

# Launch a webapp directly
webapp-launch "https://example.com"
```

Webapps appear in Rofi and launch in Chromium's app mode (no browser chrome, separate window).

### Service Management
```bash
# Restart bluetooth
restart-bluetooth

# Restart audio (PipeWire/PulseAudio)
restart-audio

# Restart NetworkManager
restart-network
```

## Optional Setup Scripts

Run these as needed for additional hardware/features:

```bash
cd ~/.dotfiles/linux/arch/setup/config

# Bluetooth support
./bluetooth.sh

# Audio support (PipeWire)
./audio.sh

# Touchpad support (for laptops)
./touchpad.sh

# Firewall (UFW - deny all incoming, allow tailscale)
./firewall.sh

# Tailscale VPN
./tailscale.sh
```

## Manual Steps

### Re-stow Dotfiles

If you need to re-stow configs later:

```bash
cd ~/.dotfiles
make linux
```

### Update Helper Scripts

If you modify scripts in `linux/arch/bin/`:

```bash
cd ~/.dotfiles
make linux-arch
```

## Logging

Installation logs are saved to `/tmp/linux-arch-setup-install.log`

View the log:
```bash
cat /tmp/linux-arch-setup-install.log
```

## Adding Custom Webapps

Find icons at [Dashboard Icons](https://dashboardicons.com)

Interactive mode:
```bash
webapp-install
```

Or specify directly:
```bash
webapp-install "Gmail" "https://mail.google.com" "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png"
```

## Troubleshooting

### Webapps not appearing in Rofi

Update Rofi's cache:
```bash
rofi -show drun -modi drun
```

### Helper scripts not in PATH

Add to your `~/.bashrc` or `~/.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload:
```bash
source ~/.bashrc  # or ~/.zshrc
```

### Chromium not launching webapps

Check if Chromium is installed:
```bash
pacman -Q chromium
```

If not installed:
```bash
sudo pacman -S chromium
```

## Customization

### Adding Packages

Edit `packages/base.packages` or `packages/aur.packages` and run:
```bash
./packages/install.sh
```

### Pre-configured Webapps

Edit `config/webapps.sh` to add more default webapps.

### Helper Scripts

Add custom scripts to `linux/arch/bin/usr/local/bin/` and run:
```bash
cd ~/.dotfiles
make linux-arch
```

## Tips

- Use `gum` (installed by default) for interactive scripts
- Webapps can be launched with keyboard shortcuts in i3
- All helper scripts support `--help` or running without arguments for usage info
- Package lists support comments and blank lines for organization
