{
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages = with pkgs; [
    git-credential-manager
  ];
}
