{ config, lib, pkgs, ... }:

{
  options.hardware.nvidia.prime.enable = lib.mkEnableOption "NVIDIA PRIME hybrid graphics";

  config = lib.mkIf config.hardware.nvidia.prime.enable {
    hardware.nvidia = {
      prime = {
        sync.enable = lib.mkDefault true;
        offload = {
          enable = lib.mkDefault false;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
