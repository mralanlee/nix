{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    userEmail = "alan@drumwave.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOy9DqYxurmsXbW0bm0/L3gYgKfg850MsTlA4afSjf5r alan@drumwave.com";
    };
  };
  programs.gh.gitCredentialHelper.enable = true;
}
