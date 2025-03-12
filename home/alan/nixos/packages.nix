{pkgs, ...}: {
  home.packages = with pkgs; [
    zoom-us
    aws-workspaces
    obsidian
    hyprpaper
    hyprlock
    openconnect
    gpclient
    gpauth
    slack
  ];
}
