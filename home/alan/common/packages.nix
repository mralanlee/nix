{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    devbox
    telegram-desktop
    signal-desktop
    discord
    nodejs
  ];
}
