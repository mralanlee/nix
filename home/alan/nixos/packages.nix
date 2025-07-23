{
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages = with pkgs; [
    obsidian
    hyprpaper
    rofi-wayland
    hyprlock
    hypridle
    inputs.zen-browser.packages."${system}".twilight
    git-credential-manager
    redisinsight

    bluebubbles
    railway

    # Ghostty with epoll workaround for kernel 6.9+ performance issue
    # https://github.com/NixOS/nixpkgs/issues/421442
    (ghostty.overrideAttrs (_: {
      preBuild = ''
        shopt -s globstar
        sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
        shopt -u globstar
      '';
    }))
    zoom-us

    # waybar dependencies
    pavucontrol
    networkmanagerapplet # provides nm-connection-editor
    networkmanager # provides nmtui for terminal-based network management
    gnome-power-manager # provides gnome-power-statistics
    wireplumber # provides wpctl for audio controls

    # function key support
    brightnessctl # brightness controls for Framework laptop
    playerctl # media controls
  ];
}
