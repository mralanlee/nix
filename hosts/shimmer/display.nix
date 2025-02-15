{
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "hyprland";

      gdm = {
        enable = true;
        wayland = true;
      };
    };
    windowManager.hypr.enable = true;
  };
}
