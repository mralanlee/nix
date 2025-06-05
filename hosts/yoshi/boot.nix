{
  pkgs,
  ...
}: {
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  console.earlySetup = false;
  console = {
    font = "ter-132b";  # Replace with your chosen font
    packages = with pkgs; [ terminus_font ]; # Ensure the font package is included
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "1";
  
  # Optimize boot for faster GDM startup
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
}
