{pkgs, ...}: {
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  environment.systemPackages = with pkgs; [
    age
    alacritty
    git
    ripgrep
    lazygit
    google-chrome
    libgcc
    xclip
    gnumake
    waybar
    kitty
    rofi-wayland
    wayland
    wayland-protocols
    wayland-utils
    wl-clipboard
    xwayland
    wlroots
    wlprop
    wlr-randr
    qt6.qtwayland
    qt5.qtwayland
  ];
}
