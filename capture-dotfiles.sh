#!/usr/bin/env bash
# This script reads your existing dotfiles and generates nix config

echo "Capturing your dotfiles..."

cat > dotfiles.nix << 'NIXEOF'
{ config, pkgs, ... }:
{
  # Auto-generated dotfiles configuration
  
NIXEOF

# Capture Hyprland config
if [ -f "/home/evanh/.config/hypr/hyprland.conf" ]; then
    echo "  environment.etc.\"dotfiles/hyprland.conf\".text = ''" >> dotfiles.nix
    cat /home/evanh/.config/hypr/hyprland.conf >> dotfiles.nix
    echo "  '';" >> dotfiles.nix
    echo "" >> dotfiles.nix
fi

# Capture Neovim config  
if [ -f "/home/evanh/.config/nvim/init.lua" ]; then
    echo "  environment.etc.\"dotfiles/nvim/init.lua\".text = ''" >> dotfiles.nix
    cat /home/evanh/.config/nvim/init.lua >> dotfiles.nix
    echo "  '';" >> dotfiles.nix
    echo "" >> dotfiles.nix
fi

# Add the activation script
cat >> dotfiles.nix << 'NIXEOF'
  # Automatically restore dotfiles on rebuild
  system.activationScripts.setupUserDotfiles = ''
    echo "Setting up dotfiles for evanh..."
    mkdir -p /home/evanh/.config/hypr
    mkdir -p /home/evanh/.config/nvim
    
    ln -sf /etc/dotfiles/hyprland.conf /home/evanh/.config/hypr/hyprland.conf 2>/dev/null || true
    ln -sf /etc/dotfiles/nvim/init.lua /home/evanh/.config/nvim/init.lua 2>/dev/null || true
    
    chown -R evanh:users /home/evanh/.config 2>/dev/null || true
  '';
}
NIXEOF

echo "Generated dotfiles.nix"
