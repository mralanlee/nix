{pkgs, ...}: {
  encironment.systemPackages = with pkgs; [
    alacritty
    ripgrep
    google-chrome
  ];
}
