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

  # Bootstrap the binary on first activation. Only when missing (updates stay
  # manual via `sallyport-update`), and never fatal: gh may be logged out or offline.
  home.activation.sallyport = lib.mkIf (hostname == "canary") (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -x "$HOME/.local/bin/sallyport" ]; then
        run ${sallyport-update}/bin/sallyport-update \
          || echo "sallyport: install skipped; run 'sallyport-update' after 'gh auth login'" >&2
      fi
    ''
  );
}
