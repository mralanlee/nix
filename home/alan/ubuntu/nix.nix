{pkgs, ...}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
}