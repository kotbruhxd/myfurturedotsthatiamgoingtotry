{ pkgs, ... }:

{
  programs.nh = {
    enable = true;
    clean = {
      enable = false;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/$USER/myfurturedots/end4/dots-hyprland";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
