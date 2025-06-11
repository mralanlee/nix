{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelParams = [
      "intel_pstate=disable"
      "i915.force_probe=7d55"
      "i915.enable_psr=0"
      "usbcore.autosuspend=-1"
      "threadirqs"
      # Safe boot optimizations
      "quiet"
      "loglevel=3"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    initrd = {
      kernelModules = ["xe"];
      # Faster compression
      compressor = "zstd";
      compressorArgs = ["-19" "-T0"];
    };
    kernelPackages = pkgs.linuxPackages_latest;

    # Reduce boot verbosity
    consoleLogLevel = 3;

    # Kernel sysctl optimizations
    kernel.sysctl = {
      # Memory management
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 3;
      "vm.dirty_background_ratio" = 2;

      # Disable watchdog for performance
      "kernel.nmi_watchdog" = 0;
    };
  };
}
