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
        modules-right = ["tray" "battery" "wireplumber" "wireplumber#microphone" "network"];

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

        wireplumber = {
          scroll-step = 5;
          format = "{icon}";
          format-muted = "🔇";
          format-icons = ["🔇" "🔉" "🔊"];
          tooltip-format = "{volume}% volume";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "audio-menu-dropdown";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };

        "wireplumber#microphone" = {
          format = "{icon}";
          format-muted = "🎤";
          format-icons = ["🎙️"];
          tooltip-format = "Microphone: {volume}%";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-click-right = "mic-menu-dropdown";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
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
        background: rgba(18, 12, 25, 0.85);
        color: rgba(230, 220, 255, 0.9);
        border-radius: 12px;
        border: 1px solid rgba(138, 97, 255, 0.2);
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4), 0 0 40px rgba(138, 97, 255, 0.1);
      }

      window#waybar.hidden {
        opacity: 0;
      }

      /* Workspaces */
      #workspaces {
        background: rgba(138, 97, 255, 0.15);
        border-radius: 8px;
        padding: 2px;
        margin-left: 6px;
        border: 1px solid rgba(138, 97, 255, 0.25);
      }

      #workspaces button {
        color: rgba(230, 220, 255, 0.6);
        background: transparent;
        border-radius: 6px;
        padding: 0 10px;
        margin: 0 2px;
        min-width: 28px;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        background: rgba(255, 102, 145, 0.2);
        color: rgba(255, 200, 220, 0.9);
        box-shadow: 0 0 8px rgba(255, 102, 145, 0.3);
      }

      #workspaces button.active {
        background: linear-gradient(135deg, rgba(255, 102, 145, 0.3), rgba(138, 97, 255, 0.3));
        color: #ffffff;
        border: 1px solid rgba(255, 102, 145, 0.4);
        box-shadow: 0 0 12px rgba(255, 102, 145, 0.4);
      }

      #workspaces button.urgent {
        background: rgba(255, 102, 145, 0.4);
        color: #ff6691;
        animation: pulse 1.5s ease-in-out infinite;
      }

      @keyframes pulse {
        0% { box-shadow: 0 0 0 0 rgba(255, 102, 145, 0.4); }
        50% { box-shadow: 0 0 10px 3px rgba(255, 102, 145, 0.4); }
        100% { box-shadow: 0 0 0 0 rgba(255, 102, 145, 0.4); }
      }

      /* Clock - Center */
      #clock {
        font-weight: 400;
        color: rgba(230, 220, 255, 0.9);
        padding: 0 12px;
        text-shadow: 0 0 10px rgba(138, 97, 255, 0.3);
      }

      /* Right side modules */
      .modules-right {
        margin-right: 6px;
      }

      #tray,
      #battery,
      #network,
      #wireplumber {
        color: rgba(230, 220, 255, 0.8);
        padding: 0 8px;
        margin: 0 2px;
        border-radius: 6px;
        transition: all 0.2s ease;
      }

      #tray:hover,
      #battery:hover,
      #network:hover,
      #wireplumber:hover {
        background: rgba(138, 97, 255, 0.15);
        color: rgba(255, 200, 220, 1);
        box-shadow: 0 0 8px rgba(138, 97, 255, 0.3);
      }

      /* Tray */
      #tray {
        background: rgba(138, 97, 255, 0.08);
        border-radius: 8px;
        padding: 0 6px;
        border: 1px solid rgba(138, 97, 255, 0.15);
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      /* Battery */
      #battery.charging {
        color: #8a61ff;
        text-shadow: 0 0 8px rgba(138, 97, 255, 0.5);
      }

      #battery.warning:not(.charging) {
        color: #ff6691;
        text-shadow: 0 0 8px rgba(255, 102, 145, 0.5);
      }

      #battery.critical:not(.charging) {
        color: #ff3366;
        animation: blink 1s linear infinite alternate;
        text-shadow: 0 0 10px rgba(255, 51, 102, 0.8);
      }

      @keyframes blink {
        to {
          opacity: 0.5;
        }
      }

      /* Network */
      #network.disconnected {
        color: rgba(230, 220, 255, 0.3);
      }

      /* Audio */
      #wireplumber.muted {
        color: rgba(230, 220, 255, 0.3);
      }


      /* Tooltips */
      tooltip {
        background: rgba(18, 12, 25, 0.95);
        border: 1px solid rgba(138, 97, 255, 0.3);
        border-radius: 8px;
        padding: 8px 12px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5), 0 0 20px rgba(138, 97, 255, 0.2);
      }

      tooltip label {
        color: rgba(230, 220, 255, 0.9);
        font-size: 13px;
      }
    '';
  };
}
