{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        settings = {
          daemon.AutomaticLoginEnable = false;
          daemon.WaylandEnable = true;
        };
        wayland = true;
      };
    };
  };

  # Copy GDM monitor configuration for external monitor support
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${../../home/alan/dotfiles/gdm/monitors.xml}"
  ];

  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };
}
