{pkgs, ...}: {
  imports = [
    ../../os/darwin
  ];

  networking.hostName = "yoshi-mac";

  home-manager.users.alan.home.sessionPath = ["$HOME/.local/bin"];

  homebrew = {
    brews = [
      "withgraphite/tap/graphite"
    ];
    casks = [
      "tailscale-app"
      "claude"
    ];
  };
}
