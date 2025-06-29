{pkgs, ...}: {
  # Configure cursor theme consistently across all applications
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  # GTK cursor configuration
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };

  # Qt cursor configuration
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}