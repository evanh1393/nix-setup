{ config, lib, pkgs, ... }:

{
  options = {
    graphics.amd.enable = lib.mkEnableOption "AMD graphics support";
  };

  config = lib.mkIf config.graphics.amd.enable {
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

    # AMD specific configuration
    hardware.amdgpu = {
      initrd.enable = true;
      amdvlk = {
        enable = true;
        support32Bit = true;
      };
    };

    # Performance optimizations
    boot.kernelParams = [ "amdgpu.dc=1" ];
  };
}
