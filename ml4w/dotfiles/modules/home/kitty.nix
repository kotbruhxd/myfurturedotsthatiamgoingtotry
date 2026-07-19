{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono NF";
      size = 10;
    };
    settings = {
      confirm_os_window_close = -1;
      enable_audio_bell = false;
      hide_window_decorations = true;
      window_padding_width = 4;
      background_opacity = "0.95";
      shell = "fish";
      editor = "nvim";
    };
    themeFile = "Catppuccin-Mocha";
  };
}
