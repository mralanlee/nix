{pkgs, ...}: {
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
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
