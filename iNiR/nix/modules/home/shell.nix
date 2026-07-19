{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      g = "git";
      ls = "eza --icons";
      ll = "eza --icons -la";
      lt = "eza --icons --tree";
      cat = "bat";
    };
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/arseniy/myfurturedots/iNiR#desktop";
    };
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
  };

  programs.bat = {
    enable = true;
    config.theme = "Catppuccin Mocha";
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings.add_newline = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
