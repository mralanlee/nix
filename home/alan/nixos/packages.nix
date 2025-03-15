{pkgs, inputs, system, ...}: {
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
    inputs.zen-browser.packages."${system}".twilight
  ];
}
