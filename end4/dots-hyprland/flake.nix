{
  description = "illogical-impulse (end4) desktop shell for Hyprland, NixOS configuration";

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
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
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

  outputs = { self, inputs, nixpkgs, home-manager, quickshell, catppuccin, nur, lanzaboote, spicetify-nix }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "illogical-impulse-quickshell-wrapper";
        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildInputs = [ quickshell.packages.${system}.default ];
        installPhase = ''
          mkdir -p $out/bin
          makeWrapper ${quickshell.packages.${system}.default}/bin/qs $out/bin/qs \
            --prefix XDG_DATA_DIRS : ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}
        '';
        meta = with pkgs.lib; {
          description = "Quickshell bundled for illogical-impulse";
          license = licenses.gpl3Only;
        };
      };

      nixosModules.default = { config, lib, pkgs, ... }: {
        imports = [ ./hosts/nikospc ];
      };

      homeModules.default = { config, lib, pkgs, ... }: {
        imports = [ ./modules/home ];
      };

      homeManagerModules.default = self.homeModules.default;

      nixosConfigurations = {
        %%HOSTNAME%% = lib.nixosSystem {
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
              home-manager.users.%%USERNAME%% = import ./modules/home;
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
