# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;
  };
  boot.loader.timeout = 100000000;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "boccher"; # Define your hostname.

  #enable sudo
  security.sudo.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];
    
    sound.enable=true;
    hardware.enableAllFirmware  = true;
    boot.extraModprobeConfig = ''
        options snd-intel-dspcfg dsp_driver=1
    ''; 

#   nix.settings.experimental-features = ["nix-command" "flakes"];
#  i18n.extraLocaleSettings = {
#    LC_ADDRESS = "sl_SI.UTF-8";
#    LC_IDENTIFICATION = "sl_SI.UTF-8";
#    LC_MEASUREMENT = "sl_SI.UTF-8";
#    LC_MONETARY = "sl_SI.UTF-8";
#    LC_NAME = "sl_SI.UTF-8";
#    LC_NUMERIC = "sl_SI.UTF-8";
#    LC_PAPER = "sl_SI.UTF-8";
#    LC_TELEPHONE = "sl_SI.UTF-8";
#    LC_TIME = "sl_SI.UTF-8";
#  };


  # Add unstable and old nerd fonts
  # Allow unfree packages
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {config.allowUnfree = true;};
  };
  nixpkgs.config.allowUnfree = true;

 hardware.opengl = {
    enable = true;
   # extraPackages = [ pkgs.unstable.mesa ];
    driSupport32Bit = true;
    extraPackages32 = [ 
        pkgs.unstable.pkgsi686Linux.mesa 
    ];
    extraPackages = with pkgs; [
      pkgs.unstable.mesa
      #...  # your Open GL, Vulkan and VAAPI drivers
      # vpl-gpu-rt          # for newer GPUs on NixOS >24.05 or unstable
       onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
  };
  
 fonts = {
  enableDefaultPackages = true;

  packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    ubuntu_font_family
    unifont
  ];

  fontconfig = {
    antialias = true;
    defaultFonts = {
      serif = [ "Ubuntu" ];
      sansSerif = [ "Ubuntu" ];
      monospace = [ "Ubuntu Source" ];
    };
  };
};   

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    videoDrivers = [
      "intelgpu"
    ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  #docker 
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.boccher = {
    isNormalUser = true;
    description = "Boccher";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
  };

  users.defaultUserShell = pkgs.zsh;

  #symlink
  #environment.etc."/usr/bin/env/perl".source = "/run/current-system/sw/bin/perl";
   
  #udev
 services.udev.extraRules = ''
 SUBSYSTEM=="usb", ATTR{idVendor}=="03e7", ATTR{idProduct}=="2485", MODE="0666",
 '';

#virtual box
virtualisation.virtualbox.host.enable = true;
users.extraGroups.vboxusers.members = [ "boccher" ];
#virtualisation.virtualbox.guest.enable = true;

  # jp input
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-configtool
      fcitx5-mozc
      fcitx5-rose-pine
    ];
  };

  #fcitx shit
services.xserver.desktopManager.runXdgAutostartIfNone = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.thunar.enable=true;

 # Enable nix ld
 # programs.nix-ld.enable = true;
 #programs.nix-ld.libraries = with pkgs; [
 #   stdenv.cc.cc
 #   zlib
 #   fuse3
 #   icu
 #   nss
 #   openssl
 #   curl
 #   expat
 # ];

  environment.systemPackages = with pkgs; [
    pcl
    gtk2-x11
    gtk3
    pkg-config
    utillinux
    usbutils
    fish
    libreoffice-qt
    qalculate-gtk
    htop
    qbittorrent
    p7zip
    sof-firmware
    wev
    noto-fonts-cjk
    libpqxx
    obsidian
    zathura
    perl
    curl
    opencv
    vscode.fhs
    wl-gammarelay-rs
    mpv
    brightnessctl
    nwg-look
    neovim
    kitty
    firefox
    anki-bin
    lf
    rofi-wayland
    wofi
    waybar
    rustup
    steam
    stow
    #gnome.nautilus
    #cmake
    yazi
    mate.caja
    wireplumber
    pipewire
    vlc
    unstable.spacedrive
    git
    pavucontrol
    playerctl
    unstable.vesktop
    unzip
    dmidecode
    neofetch
    wl-clipboard
    grim
    slurp
    grimblast
    oh-my-zsh
    libgcc
    python3
    libclang
    libstdcxx5
    bear
    gcc
    gnumake
    gdb
    libpkgconf
    lua-language-server
    ripgrep
    unstable.obs-studio
    tmux
    ntfs3g
    nvd
    gimp
    feh
    xdg-utils
    llvmPackages_17.libllvm
    qemu
    unstable.hyprpaper
    btop
    swaynotificationcenter
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.hyprland.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      update = "/home/boccher/dotfiles/scripts/update.sh";
      nconf = "nvim /home/boccher/dotfiles/nixconf/configuration.nix";
      #tershell = "cd /home/nejc/programming/Terralistic && nix-shell -p gcc pkg-config SDL2 xorg.libXext xorg.libXi xorg.libXcursor xorg.libXrandr xorg.libXScrnSaver --command 'zsh -c nvim .'";
    };
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
  };

  programs.steam.enable = true;

  #make electron apps work
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "Sway";
 };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
