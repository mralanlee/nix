{pkgs, ...}: {
  # Set wallpaper on macOS using osascript
  home.activation.setWallpaper = {
    after = ["writeBoundary"];
    before = [];
    data = ''
      $DRY_RUN_CMD /usr/bin/osascript -e 'tell application "Finder" to set desktop picture to POSIX file "${../assets/bg/hk1.png}"'
    '';
  };
}
