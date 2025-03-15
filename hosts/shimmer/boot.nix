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
    kernelParams = [ "intel_pstate=disable" "i915.force_probe=7d55" "i915.enable_psr=0" "usbcore.autosuspend=-1" "threadirqs" ];
    initrd = {
      kernelModules = ["xe"];
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
