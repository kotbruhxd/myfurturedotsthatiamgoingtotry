{ config, lib, pkgs, ... }:

{
  options.hardware.intel.enable = lib.mkEnableOption "Intel GPU support";

  config = lib.mkIf config.hardware.intel.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.intel-media-driver
      ];
    };

    environment.variables = {
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";
    };
  };
}
