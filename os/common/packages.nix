{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    ripgrep
    spicetify-cli
    sops
    age
  ];
}
