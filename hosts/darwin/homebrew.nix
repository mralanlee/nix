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
      { name = "nikitabobko/homebrew-tap"; }
    ];

    casks = [
      "1password"
      "1password-cli"
      "aerospace"
      "betterdisplay"
      "karabiner-elements"
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
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
