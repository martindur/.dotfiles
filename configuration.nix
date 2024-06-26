# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  nixpkgs.overlays = [ (import /home/dur/extras/nixpkgs-mozilla/firefox-overlay.nix) ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dur = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
	# essentials
	gnumake
	cmake
	libtool
	shellcheck
	binutils
	glibc
	gcc
	stow
	universal-ctags
	git
	ripgrep
	fzf
	fd
	bat
	xclip
  ffmpeg-full
	wezterm
  yazi
	unstable.neovim
	unstable.helix
	tree-sitter
	nodejs
	pandoc # document transpiler (e.g. markdown compiling)

	# apps
    firefox
    thunderbird
    lazygit
    google-chrome
    tree
    rofi
    discord
    slack
    youtube-music
    flameshot
    vlc
    imagemagick
    unzip
    ngrok
    reaper # audio DAW
    insomnia

    # programming
    erlang
    elixir
    unstable.gleam
    python3
    typescript
    rustup # Rust toolchain (cargo etc.)
    python311Packages.nose3
    python311Packages.pytest
    python311Packages.setuptools
    python311Packages.pyflakes
    python311Packages.debugpy
    python311Packages.python-lsp-server
    isort
    pipenv
    black
    nixfmt # nix formatter
    html-tidy # validator and 'tidier' for html
    stylelint # linting for css
    jsbeautifier # code formatting for JS/CSS/HTML
    rebar3 # erlang build tool
    shfmt
    inotify-tools
    flyctl
    yarn
    bun
    postgresql_16_jit
    love # 2d game engine
    vifm-full

    # LSPs
    nodePackages.pyright
    nodePackages.svelte-language-server
    nodePackages.typescript-language-server
    lua-language-server
    elixir-ls
    vscode-langservers-extracted
    ruff-lsp

	# extras
	zsh-vi-mode
	bluez
	fira-code-symbols
    ];
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
  };

  hardware.bluetooth.enable = true;

  networking.hostName = "techjanitor"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
      enable = true;
      xkb.layout = "us";
      videoDrivers = ["nvidia"];
      
      desktopManager = {
	xterm.enable = false;
	wallpaper.mode = "fill"; # wallpaper default path looks in ~/.background-image
      };

      displayManager = {
	defaultSession = "none+i3";
	lightdm.greeters.slick.enable = true;
	lightdm.greeters.slick.draw-user-backgrounds = true;
      };

      windowManager.i3 = {
	enable = true;
	extraPackages = with pkgs; [
	  dmenu
	  i3status
	  i3lock
	  i3-auto-layout
	];
      };
  };

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;
    open = false;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    enableNvidia = true;
  };

  # libnvidia-container does not support cgroups v2 (prior to 1.8.0)
  # https://github.com/NVIDIA/nvidia-docker/issues/1447
  systemd.enableUnifiedCgroupHierarchy = false;

  virtualisation.oci-containers.backend = "docker";

  

  # Configure keymap in X11
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  services.tailscale.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim-full # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    steam-run # intended for running steam executables (gaming), but can be used to run other downloaded binaries, e.g. LSPs
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # sync things
  # Go to localhost:8384 to see the web interface
  services.syncthing = {
      enable = true;
      user = "dur";
      dataDir = "/home/dur/documents";
      configDir = "/home/dur/.config/syncthing";
  };

  programs.zsh = {
	enable = true;
	autosuggestions.enable = true;
	syntaxHighlighting.enable = true;
  };

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  programs.steam.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

