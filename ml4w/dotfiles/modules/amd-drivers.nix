{ config, lib, pkgs, ... }:

{
  options.hardware.amdgpu.enable = lib.mkEnableOption "AMD GPU support";

  config = lib.mkIf config.hardware.amdgpu.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr.icd
      ];
    };
    hardware.amdgpu.amdvlk.enable = true;
    environment.variables.AMD_VULKAN_ICD = "RADV";
  };
}
