{pkgs, ...}: {
  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "rgb";
    defaultFonts = {
      monospace = ["JetBrains Mono"];
      sansSerif = ["Inter" "Liberation Sans"];
      serif = ["Liberation Serif"];
    };
  };
}
