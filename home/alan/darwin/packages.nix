{
  pkgs,
  lib,
  hostname,
  ...
}: let
  # Sallyport cannot be a normal nix package: its go.mod needs a private repo
  # that only a GitHub App token can reach, so the signed release tarballs are
  # the only route. See the script's header comment for the full reasoning.
  sallyport-update = pkgs.writeShellApplication {
    name = "sallyport-update";
    runtimeInputs = with pkgs; [gh gnutar coreutils];
    text = builtins.readFile ../assets/scripts/sallyport-update;
  };
in {
  # canary is the work machine; sallyport is Canary-internal tooling.
  home.packages = lib.optionals (hostname == "canary") [
    sallyport-update
  ];

  # sallyport-update installs into ~/.local/bin, so put it on PATH.
  home.sessionPath = ["$HOME/.local/bin"];
}
