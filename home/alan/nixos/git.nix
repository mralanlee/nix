{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    userEmail = "alanleunglee@gmail.com";
  };
  programs.gh.gitCredentialHelper.enable = true;
}
