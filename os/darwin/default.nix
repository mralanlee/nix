{pkgs, ...}: {
  imports = [
    ../common
    ./homebrew.nix
    ./nix.nix
    ./packages.nix
    # ./sops.nix
  ];

  system.primaryUser = "alan";
  users.users.alan.home = "/Users/alan";
  programs.zsh.enable = true;

  fonts.packages = [];

  system.stateVersion = 6;
}
