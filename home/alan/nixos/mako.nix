{pkgs, ...}: {
  services.mako = {
    enable = true;
    
    settings = {
      # Basic configuration
      anchor = "top-right";
      default-timeout = 5000; # 5 seconds
      ignore-timeout = false;
      
      # Appearance
      font = "JetBrainsMono Nerd Font 11";
      width = 300;
      height = 110;
      margin = "10";
      padding = "15";
      border-size = 1;
      border-radius = 12;
      icons = true;
      max-icon-size = 48;
      markup = true;
      format = "<b>%s</b>\\n%b";
      
      # Colors - matching waybar dark theme
      background-color = "#161616e6"; # rgba(22, 22, 22, 0.9)
      text-color = "#ffffffe6"; # rgba(255, 255, 255, 0.9)
      border-color = "#ffffff1a"; # rgba(255, 255, 255, 0.1)
      progress-color = "#ffffff33"; # rgba(255, 255, 255, 0.2)
      
      # Interaction
      actions = true;
      max-visible = 5;
      layer = "overlay";
      
      # Low urgency
      "[urgency=low]" = {
        background-color = "#161616e6";
        text-color = "#ffffff99";
        border-color = "#ffffff0d";
        default-timeout = 3000;
      };
      
      # High urgency
      "[urgency=high]" = {
        background-color = "#ff453a4d";
        text-color = "#ff453a";
        border-color = "#ff453a66";
        default-timeout = 0;
      };
      
      # Group by app
      "[grouped]" = {
        format = "<b>%s</b> [%g]\\n%b";
      };
      
      # Special apps
      "[app-name=\"Spotify\"]" = {
        default-timeout = 2000;
      };
      
      "[app-name=\"Discord\"]" = {
        default-timeout = 4000;
      };
      
      # Hide notifications in fullscreen
      "[mode=do-not-disturb]" = {
        invisible = 1;
      };
    };
  };
  
  # Ensure mako starts with Hyprland
  home.packages = with pkgs; [
    libnotify # For testing notifications with notify-send
  ];
}