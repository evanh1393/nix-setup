{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/development.nix
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

  # Graphics and display
  hardware.graphics.enable = true;

  # System packages - Hyprland essentials + development tools
  environment.systemPackages = with pkgs; [
    # Basic system tools
    vim
    neovim
    git
    curl
    wget
    firefox
    
    # Hyprland ecosystem
    hyprland
    eww
    waybar          # Alternative bar
    rofi-wayland    # App launcher
    dunst           # Notifications
    swww            # Wallpaper
    grim            # Screenshots
    slurp           # Screen area selection
    wl-clipboard    # Clipboard
    swaynotificationcenter
    
    # Terminal and shell
    ghostty         # Terminal
    fish            # Shell (since you're using fish)
    fastfetch 

    # File manager
    # thunar
    
    # Common utilities
    htop
    neofetch
    tree
    unzip
    
    # Development extras
    # vscode
    postman
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
  ];

  system.stateVersion = "25.05";
}
