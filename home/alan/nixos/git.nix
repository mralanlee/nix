{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    userEmail = "alanleunglee@gmail.com";
    extraConfig = {
      credential.helper = "manager";
    };
  };
  programs.gh.gitCredentialHelper.enable = true;
}
