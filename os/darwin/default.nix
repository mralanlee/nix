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

  fonts.packages =
    if pkgs ? nerdfonts then
      [
        (pkgs.nerdfonts.override {
          fonts = ["FiraCode" "JetBrainsMono" "NerdFontsSymbolsOnly"];
        })
      ]
    else
      [
        pkgs."nerd-fonts".fira-code
        pkgs."nerd-fonts".jetbrains-mono
        pkgs."nerd-fonts".symbols-only
      ];

  system.stateVersion = 6;
}
