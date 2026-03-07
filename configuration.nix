{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./sddm-minimal.nix
    <home-manager/nixos>
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cube";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.k3s = {
    enable = true;
    role = "server";
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];

  environment.systemPackages = with pkgs; [
    nodejs
    rustc
    cargo
    go
    python3

    ghostty
    chromium
    nautilus
    wofi
    waybar
    mako
    swaybg
    swaynotificationcenter
    hyprlock
    hypridle
    wl-clipboard
    grim
    slurp
    playerctl
    pavucontrol
    networkmanagerapplet
    brightnessctl
    nwg-look
    gcc
    pkg-config
    sqlite

    curl
    wget
    dig
    traceroute
    mtr
    nmap
    tcpdump
    ethtool
    iperf3
    bind
    dnsutils
    inetutils
    usbutils
    pciutils
    lm_sensors
    iftop

    git
    gh
    gnupg
    pinentry-curses
    vim
    neovim
    tmux
    htop
    btop
    jq
    yq-go
    ripgrep
    fd
    bat
    eza
    fzf
    tree
    file
    which
    unzip
    zip
    gnutar
    rsync
    lsof

    nushell
    starship
    zoxide
    fastfetch

    podman
    podman-compose
    kubectl
    k3s

    bibata-cursors
    source-code-pro
    adwaita-icon-theme
    gnome-themes-extra
  ];

  fonts.packages = with pkgs; [
    source-code-pro
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
    adwaita-icon-theme
  ];

  security.polkit.enable = true;
  services.dbus.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    curl
    git
    libgcc
    sqlite
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  security.rtkit.enable = true;

  security.sudo.extraRules = [
    {
      users = [ "arx" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/iftop";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  users.users.arx = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "podman" ];
    shell = pkgs.nushell;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.arx = import ./home.nix;

  system.stateVersion = "25.11";
}
