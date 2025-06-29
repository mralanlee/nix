{config, ...}: {
  # Disable GDM
  services.xserver.displayManager.gdm.enable = false;
  
  # Enable TTY autologin
  services.getty.autologinUser = "alan";
  
  # Keep minimal xserver config for compatibility
  services.xserver.enable = true;

  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  # Auto-start Hyprland on TTY1 login
  environment.loginShellInit = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
      exec Hyprland
    fi
  '';
}
