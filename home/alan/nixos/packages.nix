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

    bluebubbles
    railway
    deno

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
