{config, lib, ...}: {
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
    windowManager.hypr.enable = true;
  };
  
  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };
  
  # Configure logind for lid switch handling (only for laptops)
  services.logind = lib.mkIf config.hardware.laptop.enable {
    lidSwitch = lib.mkForce "ignore";  # Let GDM/Hyprland handle it
    lidSwitchExternalPower = lib.mkForce "ignore";
  };
}
