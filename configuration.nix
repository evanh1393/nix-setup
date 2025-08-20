{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/development.nix
    ./modules/lsp.nix
    ./modules/graphics/amd.nix
    ./modules/themes/nordzy.nix   # ✅ new Nordzy module
  ];

  nixpkgs.config.allowUnfree = true;

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "evnix";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/New_York";

  # User account
  users.users.evanh = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.enable = true;

  # Enable development environment
  development.php-laravel.enable = true;

  # Hyprland setup
  programs.hyprland.enable = true;

  # XDG portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Steam config
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;

  # System packages - Hyprland essentials + development tools
  environment.systemPackages = with pkgs; [
    # Basic system tools
    vim
    neovim
    git
    curl
    wget
    firefox
    discord

    # Hyprland ecosystem
    hyprland
    eww
    waybar
    rofi-wayland
    dunst
    hyprpaper
    grim
    slurp
    wl-clipboard
    swaynotificationcenter

    # Terminal and shell
    ghostty
    fish
    fastfetch 
    neofetch 

    # Common utilities
    htop
    tree
    unzip
    btop
    lazygit

    # Development extras
    postman

    # Games
    lutris

    # Misc
    imagemagick
    github-copilot-cli
  ];

  # Enable services
  services.openssh.enable = true;

  # Fonts (important for Hyprland)
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.iosevka
    dosis
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.fish.enable = true;
  system.stateVersion = "25.05";
}

