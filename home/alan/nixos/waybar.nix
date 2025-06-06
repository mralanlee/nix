{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;
        spacing = 0;
        margin-top = 8;
        margin-left = 10;
        margin-right = 10;
        
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["tray" "battery" "pulseaudio" "network"];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{id}";
          persistent-workspaces = {
            "*" = [1 2 3 4 5 6 7 8];
          };
          on-click = "activate";
        };
        
        tray = {
          spacing = 8;
          icon-size = 16;
        };
        
        clock = {
          format = "{:%a %b %d  %I:%M %p}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "⚡";
          format-plugged = "🔌";
          format-icons = ["🪫" "🔋" "🔋" "🔋" "🔋"];
          tooltip-format = "{capacity}% - {timeTo} ⚡ {power}W";
          on-click = "gnome-power-statistics";
        };
        
        network = {
          format-wifi = "📶";
          format-ethernet = "🌐";
          format-linked = "📡";
          format-disconnected = "❌";
          tooltip-format = "{ifname} via {gwaddr} 🚀 up: {bandwidthUpBits} down: {bandwidthDownBits}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) 📶 {frequency}MHz";
          tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr} 🌐";
          tooltip-format-disconnected = "Disconnected ❌";
          on-click = "nmtui";
          on-click-right = "nm-connection-editor";
        };
        
        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "🎧";
          format-bluetooth-muted = "🔇";
          format-muted = "🔇";
          format-icons = {
            headphone = "🎧";
            hands-free = "🎧";
            headset = "🎧";
            phone = "📱";
            portable = "🔊";
            car = "🚗";
            default = ["🔇" "🔉" "🔊"];
          };
          tooltip-format = "{desc} - {volume}%";
          on-click = "${pkgs.bash}/bin/bash /home/alan/projects/nix/home/alan/assets/scripts/audio-switcher";
          on-click-right = "pavucontrol";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };
        
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "FiraCode Nerd Font", -apple-system, BlinkMacSystemFont, "SF Pro Display", "Helvetica Neue", sans-serif;
        font-size: 14px;
        font-weight: 500;
      }

      window#waybar {
        background: rgba(22, 22, 22, 0.9);
        color: rgba(255, 255, 255, 0.9);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
      }

      window#waybar.hidden {
        opacity: 0;
      }

      /* Workspaces */
      #workspaces {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        padding: 2px;
        margin-left: 6px;
      }

      #workspaces button {
        color: rgba(255, 255, 255, 0.6);
        background: transparent;
        border-radius: 6px;
        padding: 0 10px;
        margin: 0 2px;
        min-width: 28px;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.15);
        color: rgba(255, 255, 255, 0.9);
      }

      #workspaces button.active {
        background: rgba(255, 255, 255, 0.2);
        color: #ffffff;
      }

      #workspaces button.urgent {
        background: rgba(255, 69, 58, 0.3);
        color: #ff453a;
      }

      /* Clock - Center */
      #clock {
        font-weight: 400;
        color: rgba(255, 255, 255, 0.9);
        padding: 0 12px;
      }

      /* Right side modules */
      .modules-right {
        margin-right: 6px;
      }

      #tray,
      #battery,
      #network,
      #pulseaudio {
        color: rgba(255, 255, 255, 0.8);
        padding: 0 8px;
        margin: 0 2px;
        border-radius: 6px;
        transition: all 0.2s ease;
      }

      #tray:hover,
      #battery:hover,
      #network:hover,
      #pulseaudio:hover {
        background: rgba(255, 255, 255, 0.1);
        color: rgba(255, 255, 255, 1);
      }

      /* Tray */
      #tray {
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        padding: 0 6px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      /* Battery */
      #battery.charging {
        color: #30d158;
      }

      #battery.warning:not(.charging) {
        color: #ffd60a;
      }

      #battery.critical:not(.charging) {
        color: #ff453a;
        animation: blink 1s linear infinite alternate;
      }

      @keyframes blink {
        to {
          opacity: 0.5;
        }
      }

      /* Network */
      #network.disconnected {
        color: rgba(255, 255, 255, 0.4);
      }

      /* Audio */
      #pulseaudio.muted {
        color: rgba(255, 255, 255, 0.4);
      }

      #pulseaudio.bluetooth {
        color: #0a84ff;
      }


      /* Tooltips */
      tooltip {
        background: rgba(30, 30, 30, 0.95);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        padding: 8px 12px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.4);
      }

      tooltip label {
        color: rgba(255, 255, 255, 0.9);
        font-size: 13px;
      }
    '';
  };
}