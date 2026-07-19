{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      pamixer = prev.pamixer.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ final.pkg-config ];
      });
      python3 = prev.python3.override {
        packageOverrides = finalPy: prevPy: {
          picosvg = prevPy.picosvg.overrideAttrs (_: {
            doCheck = false;
          });
        };
      };
      python3Packages = final.python3.pkgs;
    })
  ];
}
