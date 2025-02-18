{pkgs, ...}: {
  home.packages = with pkgs; [
    zoom-us
    obsidian
    hyprpaper
    openconnect
    gpclient
    gpauth
    slack
  ];
}
