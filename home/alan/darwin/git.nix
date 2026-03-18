{
  config,
  pkgs,
  ...
}: {
  # Signing configuration is handled in common/git.nix
  programs.gh.gitCredentialHelper.enable = true;
}
