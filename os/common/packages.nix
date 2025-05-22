{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    ripgrep
    google-chrome
    spotify
    spicetify-cli
  ];
}
