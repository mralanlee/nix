{pkgs, ...}: {
  imports = [
    ../../os/darwin
  ];

  networking.hostName = "yoshi-mac";

  homebrew = {
    taps = [
      {name = "withgraphite/homebrew-tap";}
    ];
    brews = [
      "withgraphite/tap/graphite"
    ];
    casks = [
      "tailscale-app"
    ];
  };
}
