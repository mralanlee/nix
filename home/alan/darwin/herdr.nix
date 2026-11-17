{
  pkgs,
  lib,
  ...
}: let
  # Herdr rewrites its config while it runs, so the files are copied into
  # ~/.config/herdr-app instead of symlinked from the store. The script's
  # header comment has the full reasoning.
  herdr-config = pkgs.writeShellApplication {
    name = "herdr-config";
    runtimeInputs = with pkgs; [rsync jq git coreutils findutils diffutils gnused gnugrep];
    text = builtins.readFile ../assets/scripts/herdr-config;
  };

  # The repo's copy plus the files nix generates. The insights mod needs the
  # path of a Node binary, which is a store path and so differs per machine.
  herdr-app-config = pkgs.runCommand "herdr-app-config" {} ''
    cp -r ${../dotfiles/herdr} $out
    chmod -R u+w $out
    if [ -d $out/mods/insights ]; then
      echo '{"node":"${pkgs.nodejs-slim}/bin/node"}' > $out/mods/insights/runtime.json
    fi
  '';
in {
  # `herdr-config backup` copies in-app edits back into this repo.
  home.packages = [herdr-config];

  # The repo is the source of truth: every rebuild installs it over the live
  # config. Files it replaces are kept in ~/.local/state/herdr-nix/replaced.
  home.activation.herdrConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${herdr-config}/bin/herdr-config apply ${herdr-app-config}
  '';
}
