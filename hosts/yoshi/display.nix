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
      
      # Check if external monitors are connected
      EXTERNAL_MONITORS=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | wc -l)
      echo "$(date): External monitors detected: $EXTERNAL_MONITORS" >> /tmp/lid-handler.log
      
      if [ "$EXTERNAL_MONITORS" -gt 0 ]; then
        # External monitor connected - don't suspend
        echo "$(date): External monitor detected, not suspending" >> /tmp/lid-handler.log
        exit 0
      else
        # No external monitor - suspend as normal
        echo "$(date): No external monitor, suspending" >> /tmp/lid-handler.log
        systemctl suspend
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
