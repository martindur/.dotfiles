# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  fileSystems."/tmp/.X11-unix/X0" = {
    device = "${config.wsl.wslConf.automount.root}/wslg/.X11-unix/X0";
    options = [ "bind" ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
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
	wezterm
	neovim
	tree-sitter
	nodejs
	pandoc # document transpiler (e.g. markdown compiling)

	# apps
    firefox
    lazygit
    tree
    imagemagick
    unzip
    ngrok

    # programming
    elixir
    python3
    python311Packages.nose3
    python311Packages.pytest
    python311Packages.setuptools
    python311Packages.pyflakes
    isort
    pipenv
    black
    nixfmt # nix formatter
    html-tidy # validator and 'tidier' for html
    stylelint # linting for css
    jsbeautifier # code formatting for JS/CSS/HTML
    shfmt
    inotify-tools
    flyctl
    yarn

    # LSPs
    nodePackages.pyright
    lua-language-server
    elixir-ls
    vscode-langservers-extracted

	# extras
	zsh-vi-mode
	bluez
	fira-code-symbols
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
      enable = true;
      xkb.layout = "us";
      videoDrivers = ["nvidia"];
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
    #enableNvidia = true;
  };

  # libnvidia-container does not support cgroups v2 (prior to 1.8.0)
  # https://github.com/NVIDIA/nvidia-docker/issues/1447
  #systemd.enableUnifiedCgroupHierarchy = false;

  virtualisation.oci-containers.backend = "docker";


  services.tailscale.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim-full # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    steam-run # intended for running steam executables (gaming), but can be used to run other downloaded binaries, e.g. LSPs
  ];

  # sync things
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

