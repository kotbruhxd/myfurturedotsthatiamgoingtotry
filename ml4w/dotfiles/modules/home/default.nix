{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./shell.nix
    ./kitty.nix
  ];

  home.stateVersion = "24.11";
}
