{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # "check" aborts activation (before any change) if unlisted packages exist,
      # instead of uninstalling them. "zap"/"uninstall" wiped every cask twice
      # (2026-08-20, 2026-09-24) after nix-homebrew brew bumps broke state detection.
      cleanup = "check";
    };
    taps = [
      # Must match nix-homebrew.taps keys in flake.nix so cleanup checks see them as kept.
      {name = "homebrew/homebrew-cask";}
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
      # Preinstalled Apple apps; listed so cleanup checks do not flag them.
      Numbers = 409203825;
      Pages = 409201541;
    };
  };
}
