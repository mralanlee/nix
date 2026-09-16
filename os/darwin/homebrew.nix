{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    taps = [
      {name = "nikitabobko/homebrew-tap";}
    ];

    casks = [
      "1password"
      "1password-cli"
      "betterdisplay"
      "claude"
      "google-chrome"
      "karabiner-elements"
      "sf-symbols"
      "font-sf-mono"
      # "font-sf-pro" # broken upstream: Apple renamed the pkg inside SF-Pro.dmg
      # to SFProFonts.pkg, cask still expects "SF Pro Fonts.pkg". Re-enable once fixed.
    ];

    brews = [
      "tfenv"
      "switchaudio-osx"
      "nowplaying-cli"
    ];

    masApps = {
      Amphetamine = 937984704;
      Flycut = 442160987;
    };
  };
}
