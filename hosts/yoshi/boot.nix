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
    # Additional safe optimizations
    "loglevel=3"
    "systemd.show_status=false"
  ];
  
  # Faster initrd compression
  boot.initrd = {
    compressor = "zstd";
    compressorArgs = ["-19" "-T0"];
  };
  
  # Reduce boot verbosity
  boot.consoleLogLevel = 3;
  
  # Kernel sysctl optimizations
  boot.kernel.sysctl = {
    # Memory management
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 3;
    "vm.dirty_background_ratio" = 2;
    
    # Disable watchdog for performance
    "kernel.nmi_watchdog" = 0;
  };
}
