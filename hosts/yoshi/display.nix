{config, lib, pkgs, ...}: {
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
  
  # Create smart lid switch script
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "smart-lid-handler" ''
      #!/bin/bash
      PATH=${lib.makeBinPath [ hyprland jq systemd coreutils ]}:$PATH
      
      # Log for debugging
      echo "$(date): Lid event triggered" >> /tmp/lid-handler.log
      
      # Check if we're in a Hyprland session
      if ! pgrep -x "Hyprland" > /dev/null; then
        echo "$(date): Hyprland not running, allowing default suspend" >> /tmp/lid-handler.log
        systemctl suspend
        exit 0
      fi
      
      # Check current lid state
      LID_STATE="open"
      if [ -f /proc/acpi/button/lid/LID0/state ]; then
        grep -q "closed" /proc/acpi/button/lid/LID0/state && LID_STATE="closed"
      fi
      
      echo "$(date): Lid state: $LID_STATE" >> /tmp/lid-handler.log
      
      if [ "$LID_STATE" = "closed" ]; then
        # Lid closed - turn off laptop display and disable fingerprint
        echo "$(date): Lid closed, turning off laptop display and disabling fingerprint" >> /tmp/lid-handler.log
        hyprctl keyword monitor "eDP-1,disable"
        # Disable fingerprint reader
        systemctl stop fprintd.service
      else
        # Lid opened - turn on laptop display and enable fingerprint
        echo "$(date): Lid opened, turning on laptop display and enabling fingerprint" >> /tmp/lid-handler.log
        hyprctl keyword monitor "eDP-1,preferred,auto,1"
        # Enable fingerprint reader
        systemctl start fprintd.service
      fi
    '')
  ];

  # Configure systemd service for smart lid handling
  systemd.services.smart-lid-handler = {
    description = "Smart lid switch handler";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/smart-lid-handler";
    };
  };

  # Configure logind for lid switch handling
  services.logind = lib.mkIf config.hardware.laptop.enable {
    lidSwitch = lib.mkForce "ignore";  # We'll handle it ourselves
    lidSwitchExternalPower = lib.mkForce "ignore";
    extraConfig = ''
      HandleLidSwitch=ignore
      HandleLidSwitchExternalPower=ignore
      HandleLidSwitchDocked=ignore
    '';
  };

  # Set up acpi event handler for lid switch
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      /run/current-system/sw/bin/smart-lid-handler
    '';
  };
}
