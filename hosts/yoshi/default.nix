{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../os/nixos
    ./boot.nix
    ./display.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "yoshi";
  networking.networkmanager.enable = true;

  networking.interfaces.wlp192s0 = {
    useDHCP = true;
    # ipv4.addresses = [
    #   {
    #     address = "192.168.86.1"; prefixLength = 24;
    #   }
    # ];
  };
  programs.nm-applet.enable = true;

  # framework 13 laptop specific
  # https://wiki.nixos.org/wiki/Hardware/Framework/Laptop_13
  services.fwupd.enable = true;

  # Enable fingerprint reader support
  services.fprintd.enable = true;

  # Add user to required groups for fingerprint access
  users.users.alan.extraGroups = ["wheel" "audio" "video" "networkmanager" "plugdev"];

  # Configure polkit for fprintd access
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "net.reactivated.fprint.device.enroll" ||
            action.id == "net.reactivated.fprint.device.verify" ||
            action.id == "net.reactivated.fprint.device.setusername") {
            return polkit.Result.YES;
        }
    });
  '';

  # Configure PAM for fingerprint authentication
  security.pam.services = {
    login.fprintAuth = false; # Disable for login to prevent conflicts
    sudo.fprintAuth = lib.mkDefault true; # Allow fingerprint OR password for sudo (with fallback)
    hyprlock = {
      fprintAuth = false; # Disable fingerprint authentication for hyprlock
    };
    gdm.fprintAuth = false; # Keep disabled to avoid breaking basic auth
    gdm-password.fprintAuth = false; # Keep disabled to avoid breaking basic auth
  };

  system.stateVersion = "25.05";
}
