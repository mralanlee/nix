{
  config,
  lib,
  pkgs,
  ...
}: {
  # Disable GDM
  services.xserver.displayManager.gdm.enable = false;
  
  # Enable TTY autologin
  services.getty.autologinUser = "alan";
  
  # Keep minimal xserver config for compatibility
  services.xserver = {
    enable = true;
    displayManager = {
      startx.enable = false;
      lightdm.enable = false;
      sddm.enable = false;
    };
  };

  services.displayManager = {
    defaultSession = "hyprland";
    autoLogin = {
      enable = true;
      user = "alan";
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };
}
