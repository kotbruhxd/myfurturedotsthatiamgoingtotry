{ config, lib, pkgs, ... }:

{
  options.programs.quickshell-ii = {
    enable = lib.mkEnableOption "illogical-impulse Quickshell shell";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.stdenv.mkDerivation {
        name = "illogical-impulse-quickshell-wrapper";
        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildInputs = [ pkgs.quickshell ];
        installPhase = ''
          mkdir -p $out/bin
          makeWrapper ${pkgs.quickshell}/bin/qs $out/bin/qs \
            --prefix XDG_DATA_DIRS : ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}
        '';
        meta = with pkgs.lib; {
          description = "Quickshell bundled for illogical-impulse";
          license = licenses.gpl3Only;
        };
      };
      description = "Quickshell package for illogical-impulse";
    };
  };

  config = lib.mkIf config.programs.quickshell-ii.enable {
    environment.systemPackages = [
      config.programs.quickshell-ii.package
      pkgs.qt6.qtbase
      pkgs.qt6.qtdeclarative
      pkgs.qt6.qtwayland
      pkgs.qt6.qtsvg
      pkgs.qt6.qtmultimedia
    ];

    environment.variables = {
      QML2_IMPORT_PATH = lib.mkDefault "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";
    };

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
  };
}
