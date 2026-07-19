{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "google-sans-flex";
  version = "1.0";
  src = pkgs.fetchzip {
    url = "https://github.com/nicholasgasior/gfonts/raw/master/fonts/google/sans-flex/GoogleSansFlex-Regular.ttf";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    stripRoot = false;
  };
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype/
  '';
  meta = with pkgs.lib; {
    description = "Google Sans Flex font";
    homepage = "https://fonts.google.com/specimen/Google+Sans+Flex";
    license = licenses.ofl;
  };
}
