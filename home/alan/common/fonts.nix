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
    hinting = {
      enable = true;
      style = "slight";
    };
    defaultFonts = {
      monospace = ["JetBrains Mono"];
      sansSerif = ["Inter" "Liberation Sans"];
      serif = ["Liberation Serif"];
    };
  };
}
