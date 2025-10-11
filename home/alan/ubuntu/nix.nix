{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  nix = {
    package = null;  # Use system nix
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
}