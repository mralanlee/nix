{
  pkgs,
  ...
}: {
  imports = [
    ./boot.nix
  ];

  networking.hostName = "yoshi";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # framework 13 laptop specific
  # https://wiki.nixos.org/wiki/Hardware/Framework/Laptop_13
  services.fwupd.enable = true;

# Enable fingerprint reader support
  services.fprintd.enable = true;
  
}
