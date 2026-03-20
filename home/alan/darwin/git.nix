{
  hostname,
  lib,
  ...
}: {
  programs.git.settings = lib.mkIf (hostname == "yoshi-mac") {
    user.email = lib.mkForce "alanleunglee@gmail.com";
    user.signingKey = lib.mkForce "";
    commit.gpgsign = lib.mkForce false;
  };
  programs.gh.gitCredentialHelper.enable = true;
}
