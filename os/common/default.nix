{
  imports = [./nix.nix ./packages.nix];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
