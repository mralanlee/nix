{pkgs, ...}: {
  imports = [
    ../common
    ./defaults.nix
    ./homebrew.nix
    ./nix.nix
    ./packages.nix
    # ./sops.nix
  ];

  system.primaryUser = "alan";
  users.users.alan.home = "/Users/alan";
  programs.zsh.enable = true;

  nixpkgs.config.allowUnsupportedSystem = true;

  # atuin 18.24.4's Pi resume tests see unrelated host processes as a live
  # session when the Darwin build is unsandboxed. Same skip as
  # https://github.com/NixOS/nixpkgs/commit/aedf37c2d5a1 ; drop after nixpkgs
  # includes that commit.
  nixpkgs.overlays = [
    (final: prev: {
      atuin = prev.atuin.overrideAttrs (old: {
        checkFlags =
          (old.checkFlags or [])
          ++ [
            "--skip=a_diverged_copy_resumes_only_as_chosen::agent_4_Agent__Pi"
            "--skip=a_session_gone_on_with_elsewhere_catches_up_where_it_came_from::agent_3_Agent__Pi"
          ];
      });
    })
  ];

  fonts.packages = [];

  system.stateVersion = 6;
}
