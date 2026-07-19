{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "arseniy";
    userEmail = "arseniy@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    delta = {
      enable = true;
      options.navigate = true;
    };
  };
}
