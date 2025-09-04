{ config, pkgs, ... }:
let
  # Import NUR (Nix User Repository)
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/development.nix
    ./modules/lsp.nix
    ./modules/graphics/amd.nix
    ./modules/kubernetes.nix
  ];
  nixpkgs.config.allowUnfree = true;
  # Pass NUR into all modules
  _module.args.nur = nur;
  
  # Nix settings for build optimization
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Reduce build parallelism to prevent memory exhaustion
    cores = 2;
    max-jobs = 2;
    # Increase build memory limits
    sandbox = true;
    # Use binary cache aggressively to avoid building Electron
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Try a more stable kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest; 
  
  # Networking
  networking.hostName = "evnix";
  networking.networkmanager.enable = true;
  # Time zone
  time.timeZone = "America/New_York";
  # User account
  users.users.evanh = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];
  };
  # Enable development environment
  development.php-laravel.enable = true;
  # Hyprland setup
  programs.hyprland.enable = true;
  # XDG portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
  # DISPLAY
  services.displayManager.sddm.enable=true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "hyprland";
  hardware.graphics.enable = true;
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

  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.override { electron = prev.electron_35-bin; };
      obsidian = prev.obsidian.override { electron = prev.electron_35-bin; };
    }
  )];
  
  # System packages - Hyprland essentials + development tools
  environment.systemPackages = with pkgs; [
    # Basic system tools
    vim
    neovim
    curl
    wget
    firefox
    vesktop          
    fd
    fzf
    vlc
    protonup-qt
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
    pavucontrol
    _1password-gui
    # Terminal and shell
    ghostty
    fish
    fastfetch
    neofetch
    nordzy-cursor-theme
    nordzy-icon-theme
    claude-code  
    ripgrep
    # Common utilities
    htop
    tree
    unzip
    btop
    git
    lazygit
    # Development extras
    postman
    # Games
    lutris
    # Misc
    imagemagick
    github-copilot-cli
    grimblast
    libnotify          # notify-send popups
    lf
    jetbrains-toolbox
    dnsutils
    stow
    starship
    obsidian          
    chromium
    whois
  ];
  
  # Build environment variables to help with Node.js memory
  environment.variables = {
    NODE_OPTIONS = "--max-old-space-size=8192";
  };
  
  # Enable services
  services.openssh.enable = true;
  # Fonts (important for Hyprland + SDDM theme)
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.iosevka
    dosis
    inter
  ];
  
  # Hyprland/Wayland will read these so the cursor shows up immediately
  environment.sessionVariables = {
    XCURSOR_THEME = "Nordzy-cursors";
    XCURSOR_SIZE  = "24";
    # Make Qt apps follow GTK so they use the same icons
    QT_QPA_PLATFORMTHEME = "gtk3";
  };
  # Set system defaults for GTK3/GTK4 (affects all users unless they override)
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-icon-theme-name=Nordzy-dark
      gtk-cursor-theme-name=Nordzy-cursors
      gtk-cursor-theme-size=24
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-icon-theme-name=Nordzy-dark
      gtk-cursor-theme-name=Nordzy-cursors
      gtk-cursor-theme-size=24
    '';
  };
  # Fish shell
  programs.fish.enable = true;
  system.stateVersion = "25.05";
}
