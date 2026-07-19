{ pkgs, ... }:

{
  imports = [
    ./home/git.nix
    ./home/shell.nix
    ./home/kitty.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
