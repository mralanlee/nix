{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../nixos
    ./boot.nix
    ./display.nix
    ./system-pkgs.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "shimmer";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    vaapiIntel
    intel-compute-runtime
    intel-media-driver
    vpl-gpu-rt
  ];

  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
  '';
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
    options snd_hda_intel enable=0,1
  '';
  system.stateVersion = "25.05";
}
