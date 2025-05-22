{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    userEmail = "alanleunglee@gmail.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMs8R1vNmoLXco86gdrVF/qkJNOruMw8XplBH4diaUhX alan.lee@procore.com";
    };
  };
  programs.gh.gitCredentialHelper.enable = true;
}
