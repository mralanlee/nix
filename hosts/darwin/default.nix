{pkgs, ...}: {
  imports = [
    ../common
    ./homebrew.nix
  ]

  users.users.alan.home = "/Users/alan";
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  security.pam.enableSudoTouchIdAuth = true;
}
