{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    ignores = [".envrc" "devbox.json" "devbox.lock"];
    extraConfig = {
      gpg.format = "ssh";
    };
    settings = {
      user.name = "Alan Lee";
      user.email = "alee@canarytechnologies.com";
      user.signingKey = "/Users/alan/.ssh/id_ed25519.pub";
      commit.gpgsign = true;
      init = {defaultBranch = "main";};
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
