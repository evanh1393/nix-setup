{ config, lib, pkgs, ... }:
{
  # AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  # Enhanced graphics support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
  
  # AMD GPU initialization in initrd
  hardware.amdgpu.initrd.enable = true;
  
  # Performance optimizations
  boot.kernelParams = [ "amdgpu.dc=1" ];
}
