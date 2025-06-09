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

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  system.stateVersion = 6;
}
