{pkgs, ...}: {
  home.packages = with pkgs; [
    zoom-us
    aws-workspaces
    obsidian
    hyprpaper
    openconnect
    gpclient
    gpauth
    slack
  ];
}
