{pkgs, ...}: {
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  environment.systemPackages = with pkgs; [
    lazygit
    xclip
    waybar
    kitty
    pavucontrol
    rofi-wayland

    # clipboard
    wl-clipboard
    cliphist

    # system
    wayshot
    swappy
    swww

    nautilus

    # wayland specific
    wayland
    wayland-protocols
    wayland-utils
    xwayland
    wlroots
    wlprop
    wlr-randr
    qt6.qtwayland
    qt5.qtwayland
  ];
}
