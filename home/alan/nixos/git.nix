{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    settings = {
      user.email = "alanleunglee@gmail.com";
    };
  };
  programs.gh.gitCredentialHelper.enable = true;
}
