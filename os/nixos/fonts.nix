{pkgs, ...}: {
  fonts.packages =
    if pkgs ? nerdfonts then
      [(pkgs.nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})]
    else
      [
        pkgs."nerd-fonts".fira-code
        pkgs."nerd-fonts".jetbrains-mono
      ];

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
      enable = true;
      style = "slight";
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
    defaultFonts = {
      monospace = ["JetBrains Mono"];
      sansSerif = ["Inter" "Liberation Sans"];
      serif = ["Liberation Serif"];
    };
  };
}
