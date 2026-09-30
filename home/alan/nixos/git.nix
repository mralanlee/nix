{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    settings = {
      user.email = lib.mkForce "alanleunglee@gmail.com";
    };
  };
  programs.gh.gitCredentialHelper.enable = true;
}
