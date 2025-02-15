{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    devbox
    discord
    nodejs
  ];
}
