{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    ripgrep
    google-chrome
    spicetify-cli
    sops
    age
  ];
}
