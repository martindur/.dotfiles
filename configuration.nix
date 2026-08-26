# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  blexMonoFont =
    if builtins.hasAttr "nerd-fonts" pkgs
    then pkgs.nerd-fonts.blex-mono
    else pkgs.nerdfonts;
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

  # nixpkgs.overlays = [ (import /home/dur/extras/nixpkgs-mozilla/firefox-overlay.nix) ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dur = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.bashInteractive;
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
      git
      ripgrep
      fzf
      fd
      bat
      xclip
      ffmpeg-full
      alacritty
      yazi
      tree-sitter
      starship
      neovim

      # apps
      firefox
      thunderbird
      lazygit
      tree
      rofi
      discord
      slack
      flameshot
      vlc
      imagemagick
      unzip
      reaper # audio DAW
      chromium

      # programming
      erlang
      elixir
      python3
      typescript
      rustup # Rust toolchain (cargo etc.)
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
      bun
      mise
      postgresql_16_jit
      love # 2d game engine
      vifm-full

      # LSPs
      nodePackages.svelte-language-server
      nodePackages.typescript-language-server
      uv
      basedpyright
      (pkgs.nodejs_24 or pkgs.nodejs_22 or pkgs.nodejs)
      lua-language-server
      elixir-ls
      vscode-langservers-extracted
      ruff

      # extras
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "nvidia" ];
    deviceSection = ''
      Option "TripleBuffer" "true"
    '';
    screenSection = ''
      Option "AllowIndirectGLXProtocol" "off"
    '';

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill"; # wallpaper default path looks in ~/.background-image
    };

    displayManager = {
      lightdm.greeters.slick.enable = true;
      lightdm.greeters.slick.draw-user-backgrounds = true;
      setupCommands = ''
        ${pkgs.xrandr or pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 3440x1440 --rate 144
      '';
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

  services.displayManager.defaultSession = "none+i3";

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;
    open = false;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Docker is currently disabled; the old enableNvidia and cgroups-v1 options
  # are obsolete on current NixOS.

  # Configure keymap in X11
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound through PipeWire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  services.tailscale.enable = true;

  fonts.packages = with pkgs; [
    blexMonoFont
  ];

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

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;

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
