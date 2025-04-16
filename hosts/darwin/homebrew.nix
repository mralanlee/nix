{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
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
    ];

    brews = [
      "tfenv"
    ];

    masApps = {
      Amphetamine = 937984704;
      Flycut = 442160987;
    };
  };
}
