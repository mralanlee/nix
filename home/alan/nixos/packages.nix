{pkgs, ...}: {
  home.packages = with pkgs; [
    zoom-us
    obsidian
    openconnect
    gpclient
    gpauth
    slack
  ];
}
