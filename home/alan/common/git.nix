{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Alan Lee";
    ignores = [".envrc" "devbox.json" "devbox.lock"];
    extraConfig = {
      init = {defaultBranch = "main";};
      gpg = {format = "ssh";};
      push = {autoSetupRemote = true;};
      pull = {rebase = true;};
    };
    delta = {enable = false;};
    difftastic = {enable = true;};
  };
  programs.gh = {
    enable = true;
    settings = {git_protocol = "https";};
    gitCredentialHelper.enable = lib.mkDefault true;
    extensions = [pkgs.gh-copilot];
  };
  programs.lazygit = {enable = true;};
  xdg.configFile.gh-copilot = {
    target = "gh-copilot/config.yml";
    text = ''
      optional_analytics: false
      suggest_execute_confirm_default: false
    '';
  };
}
