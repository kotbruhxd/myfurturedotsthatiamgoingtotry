{
  description = "ML4W dotfiles for Hyprland, NixOS configuration";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, nur, lanzaboote, spicetify-nix }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.mkDerivation {
        name = "ml4w-dotfiles";
        src = ./.;
        installPhase = "mkdir -p $out";
      };

      nixosModules.default = { config, lib, pkgs, ... }: {
        imports = [ ./hosts/nikospc ];
      };

      homeModules.default = { config, lib, pkgs, ... }: {
        imports = [ ./modules/home ];
      };

      homeManagerModules.default = self.homeModules.default;

      nixosConfigurations = {
        nikospc = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self inputs; };
          modules = [
            ./hosts/nikospc
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            lanzaboote.nixosModules.lanzaboote
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-bak";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.arseniy = import ./modules/home;
            }
            {
              nixpkgs.config.allowBroken = true;
              nixpkgs.config.allowUnfree = true;
            }
            inputs.spicetify-nix.nixosModules.default
            ({ pkgs, ... }: let
              spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
            in {
              programs.spicetify = {
                enable = true;
                theme = spicePkgs.themes.catppuccin;
                colorScheme = "mocha";
                enabledExtensions = with spicePkgs.extensions; [
                  adblockify
                  hidePodcasts
                  shuffle
                ];
              };
            })
            ({
              pkgs, lib, ...
            }: {
              environment.systemPackages = [ pkgs.sbctl ];
              boot.loader.systemd-boot.enable = lib.mkForce false;
              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
              };
            })
          ];
        };
      };

      formatter.${system} = pkgs.alejandra;
    };
}
