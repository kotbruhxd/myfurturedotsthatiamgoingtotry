{ config, lib, pkgs, ... }:

{
  options.virtualisation.vmGuest.enable = lib.mkEnableOption "VM guest services";

  config = lib.mkIf config.virtualisation.vmGuest.enable {
    services.qemuGuest.enable = lib.mkDefault true;
    services.spice-vdagentd.enable = lib.mkDefault true;
  };
}
