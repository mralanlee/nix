{...}: {
  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false; # Disable press-and-hold for keys (enables key repeat)
      KeyRepeat = 2;
      InitialKeyRepeat = 10;
    };
  };
}
