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
      rebuild = "sudo nixos-rebuild switch --flake /home/arseniy/myfurturedots/ml4w/dotfiles#nikospc";
    };
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
  };

  programs.bat = {
    enable = true;
    config.theme = "Dracula";
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
    colors = {
      bg = "#1e1e2e";
      fg = "#cdd6f4";
      "bg+" = "#313244";
      "fg+" = "#cdd6f4";
      spinner = "#f5e0dc";
      hl = "#f38ba8";
      "hl+" = "#f38ba8";
      info = "#cba6f7";
      prompt = "#cba6f7";
      "pointer" = "#f5e0dc";
      marker = "#f5e0dc";
      "border+" = "#585b70";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      auto_update = true;
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      proc_gpu = true;
    };
  };

  programs.bottom = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
}
