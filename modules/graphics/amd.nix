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

  # Exclude problematic DZN driver, keep only AMD drivers
  environment.sessionVariables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
  };
  
  # Ensure Vulkan tools are available
  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-validation-layers
  ];
}
