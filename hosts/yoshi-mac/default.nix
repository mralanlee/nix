{pkgs, ...}: {
  imports = [
    ../../os/darwin
  ];

  networking.hostName = "yoshi-mac";

  homebrew = {
    brews = [
      "withgraphite/tap/graphite"
    ];
    casks = [
      "tailscale-app"
    ];
  };
}
