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

  # Create lid detection script for fingerprint auth
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "check-lid-state" ''
      # Check if lid is closed
      if [ -f /proc/acpi/button/lid/LID0/state ]; then
        grep -q "closed" /proc/acpi/button/lid/LID0/state && exit 1
      fi
      exit 0
    '')
  ];

  # Configure PAM for fingerprint authentication
  security.pam.services = {
    login.fprintAuth = false; # Disable for login to prevent conflicts
    sudo.fprintAuth = true; # Allow fingerprint OR password for sudo
    hyprlock.fprintAuth = true;
    gdm.fprintAuth = false; # Disable default gdm fingerprint
    gdm-password.fprintAuth = false; # Disable to use custom config

    # Custom GDM fingerprint service to fix the immediate error message
    gdm-fingerprint = lib.mkIf config.services.fprintd.enable {
      text = ''
        auth       required                    pam_shells.so
        auth       requisite                   pam_nologin.so
        auth       requisite                   pam_faillock.so      preauth
        auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
        auth       optional                    pam_permit.so
        auth       required                    pam_env.so
        auth       [success=ok default=1]      ${pkgs.gdm}/lib/security/pam_gdm.so
        auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so

        account    include                     login

        password   required                    pam_deny.so

        session    include                     login
        session    optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
      '';
    };
  };

  system.stateVersion = "25.05";
}
