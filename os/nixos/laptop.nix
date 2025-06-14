{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hardware.laptop;
in {
  options.hardware.laptop = {
    enable = mkEnableOption "laptop-specific power management";
  };

  config = mkIf cfg.enable {
    # Standard laptop power management
    services.logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "suspend";  # Suspend even when plugged in to properly reinitialize display
      extraConfig = ''
        HandlePowerKey=suspend
        IdleAction=suspend
        IdleActionSec=15min
      '';
    };

    # Kernel parameters for faster resume and AMD Radeon 890M fixes
    boot.kernelParams = [
      "mem_sleep_default=deep"
      "acpi_osi=Linux"
      "nmi_watchdog=0"
      "amdgpu.dc=1"          # Enable Display Core for better display handling
      "amdgpu.sg_display=1"  # Enable scatter-gather for display (better for newer AMD APUs)
      "amdgpu.dpm=1"         # Enable dynamic power management
      "amdgpu.runpm=0"       # Disable runtime power management to prevent resume issues
    ];

    # Disable NetworkManager wait-online service to speed up resume
    systemd.services.NetworkManager-wait-online.enable = false;

    # Reduce systemd timeout for faster resume
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultTimeoutStartSec=10s
    '';

    # Power management for better battery life
    services.tlp.settings = {
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT0 = 75;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };

    # Enable power management
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    # Lock screen before suspend
    systemd.services."lock-on-suspend" = {
      description = "Lock screen before suspend";
      wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
      before = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
      serviceConfig = {
        Type = "forking";
        User = "alan";
        Environment = "DISPLAY=:0";
        ExecStart = "${pkgs.systemd}/bin/loginctl lock-sessions";
      };
    };

    # Load bluetooth module with fast resume parameters to prevent resume delays
    boot.extraModprobeConfig = ''
      options btusb enable_autosuspend=n
    '';

    # Faster NVMe resume
    services.udev.extraRules = ''
      # Disable runtime PM for NVMe
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x144d", ATTR{class}=="0x010802", ATTR{power/control}="on"

      # Disable USB autosuspend for specific devices that cause delays
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="32ac", ATTR{idProduct}=="0012", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="32ac", ATTR{idProduct}=="0014", ATTR{power/control}="on"
      
      # Fix USB controller resume issues for Bluetooth
      ACTION=="add", SUBSYSTEM=="pci", DRIVER=="xhci_hcd", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{authorized}=="1", TEST=="power/control", ATTR{power/control}="on"
    '';

    # Ensure screen locks when suspending
    # Note: Auto-login settings are handled per-host in display.nix

  };
}
