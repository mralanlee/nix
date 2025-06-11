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

      # Colors - matching waybar purple/pink theme
      background-color = "#120c19d9"; # rgba(18, 12, 25, 0.85)
      text-color = "#e6dcffe6"; # rgba(230, 220, 255, 0.9)
      border-color = "#8a61ff33"; # rgba(138, 97, 255, 0.2)
      progress-color = "#8a61ff4d"; # rgba(138, 97, 255, 0.3)

      # Interaction
      actions = true;
      max-visible = 5;
      layer = "overlay";

      # Low urgency
      "urgency=low" = {
        background-color = "#120c19d9";
        text-color = "#e6dcff99"; # slightly dimmed
        border-color = "#8a61ff1a"; # very subtle border
        default-timeout = 3000;
      };

      # High urgency
      "urgency=high" = {
        background-color = "#ff669166"; # rgba(255, 102, 145, 0.4)
        text-color = "#ffc8dc"; # pink-white
        border-color = "#ff6691b3"; # rgba(255, 102, 145, 0.7)
        default-timeout = 0;
      };

      # Group by app
      "grouped" = {
        format = "<b>%s</b> [%g]\\n%b";
      };

      # Special apps
      "app-name=Spotify" = {
        default-timeout = 2000;
        background-color = "#8a61ff26"; # slight purple tint
        border-color = "#8a61ff4d";
      };

      "app-name=Discord" = {
        default-timeout = 4000;
        background-color = "#8a61ff26"; # slight purple tint
        border-color = "#8a61ff4d";
      };

      # Bluetooth notifications
      "app-name=blueman" = {
        default-timeout = 3000;
        background-color = "#8a61ff33"; # purple tint for bluetooth
        text-color = "#e6dcffe6";
        border-color = "#8a61ff66";
      };

      # Hide notifications in fullscreen
      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };

  # Ensure mako starts with Hyprland
  home.packages = with pkgs; [
    libnotify # For testing notifications with notify-send
  ];
}
