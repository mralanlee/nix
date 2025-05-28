{config, ...}: {
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "hyprland";

      gdm = {
        enable = true;
        settings = {
          daemon.AutomaticLoginEnable = false;
        };
        wayland = true;
      };
    };
    windowManager.hypr.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };
}
