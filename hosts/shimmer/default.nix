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
    ./fonts.nix
    ./system-pkgs.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "shimmer";
  networking.networkmanager.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    vaapiIntel
    intel-media-driver
    vpl-gpu-rt
  ];

  services.xserver.videoDrivers = [ "displaylink" ];

  # thunderbolt
  services.hardware.bolt.enable = true;

  # bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
    	Experimental = true;
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
  '';
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
    options snd_hda_intel enable=0,1
  '';

  system.stateVersion = "25.05";
}
