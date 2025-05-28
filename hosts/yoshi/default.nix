{
  pkgs,
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
  
}
