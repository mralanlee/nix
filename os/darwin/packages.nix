{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sketchybar
    jankyborders
    skhd
    aerospace
  ];
}
