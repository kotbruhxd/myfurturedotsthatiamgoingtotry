{ config, lib, pkgs, ... }:

{
  options.hardware.nvidia.enable = lib.mkEnableOption "NVIDIA GPU support";

  config = lib.mkIf config.hardware.nvidia.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
