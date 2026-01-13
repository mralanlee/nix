{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    ignores = [".envrc" "devbox.json" "devbox.lock"];
    settings = {
      user.name = "Alan Lee";
      init = {defaultBranch = "main";};
      gpg = {format = "ssh";};
      push = {autoSetupRemote = true;};
      pull = {rebase = true;};
      credential = {
        credentialStore = "none";
      };
    };
  };
  programs.delta = {enable = false;};
  programs.difftastic = {
    enable = true;
    git.enable = true;
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
