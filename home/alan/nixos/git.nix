{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    userEmail = "alan.lee@procore.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMs8R1vNmoLXco86gdrVF/qkJNOruMw8XplBH4diaUhX alan.lee@procore.com";
    };
  };
  programs.gh.gitCredentialHelper.enable = true;
}
