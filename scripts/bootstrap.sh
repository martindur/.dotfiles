
# This file is meant to be an idempotent bootstrapper to get set up with existing dotfile configurations

## Check if homebrew is installed

if command -v brew > /dev/null; then
  echo brew is installed. Skipping..
else
  echo brew is not installed. Installing Homebrew..
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
fi

## Install brew packages

echo Installing brew packages from brewfile..

brew update &&
brew bundle install --cleanup --file=./homebrew/brewfile --no-lock &&
brew upgrade

## Install default system python (pyenv)

if command -v python > /dev/null; then
  echo "default Python intepreter installed: $(python --version)"
else
  echo "default Python interpreter missing. Installing Python (3.10.4)"
  pyenv install 3.10.4
  pyenv global 3.10.4
fi

## Yabai (Tiling window manager)

if [ ! -f /private/etc/sudoers.d/yabai ]; then
  echo "yabai sudo user not found. Setting up now.."
  sudo sh -c "echo \"$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai)) --load-sa\" >> /private/etc/sudoers.d/yabai"
  echo "yabai sudo user made!"

  yabai --install-service
  yabai --start-service
fi

# Key mapping
skhd --start-service
