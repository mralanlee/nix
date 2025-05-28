{pkgs, ...}: {
  imports = [
    ../common
    ../1password.nix
    ./system-pkgs.nix
    ./nix.nix
    ./fonts.nix
  ];

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8"; LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  
  programs = {
    _1password = {
      enable = true;
    };

    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["alan"];
    };
  };

  services = {
    logind.lidSwitch = "suspend-then-hibernate";
    printing.enable = true;
    openssh.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    pipewire.enable = false;
    # pipewire = {
    #   enable = true;
    #   alsa.enable = true;
    #   alsa.support32Bit = true;
    #   pulse.enable = true;
    #   jack.enable = true;
    #   wireplumber.enable = true;
    #   wireplumber.extraConfig = {};
    #
    #   extraConfig.pipewire = {
    #     "default.rt.prio" = 88;
    #     "default.rt.time.soft" = 200000;
    #     "default.rt.time.hard" = 300000;
    #     "nice.level" = -15;
    #     "default.clock.rate" = 48000;
    #     "default.clock.quantum" = 1024;
    #     "default.clock.min-quantum" = 32;
    #   };
    # };
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    tlp = {
      enable = true;
      settings = {
        USB_AUTOSUSPEND = 1;
      };
    };
  };

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

  security = {
    rtkit.enable = true;
  };

  hardware = {
    graphics.enable = true;
    enableAllFirmware = true;
    firmware = [ pkgs.firmwareLinuxNonfree ];
  };

  users.users.alan = {
    isNormalUser = true;
    description = "alan";
    ignoreShellProgramCheck = true;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };

  # sops.secrets.github_token = {
  #   format = "yaml";
  #   sopsFile = ./secrets/github_token.yaml;
  # };

  environment.variables = {
    SYSTEMD_EDITOR = "nvim";
  };

  environment.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    WLR_NO_HARDWARE_CURSORS = 1;
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    WLR_BACKEND = "gl";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}
