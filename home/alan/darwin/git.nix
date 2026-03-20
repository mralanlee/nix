{
  hostname,
  lib,
  ...
}: {
  programs.git.settings = lib.mkIf (hostname == "yoshi-mac") {
    commit.gpgsign = lib.mkForce false;
  };
  programs.gh.gitCredentialHelper.enable = true;
}
