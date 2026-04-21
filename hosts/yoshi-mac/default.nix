{pkgs, ...}: {
  imports = [
    ../../os/darwin
  ];

  networking.hostName = "yoshi-mac";

  environment.systemPackages = with pkgs; [
    tailscale
  ];

  homebrew = {
    taps = [
      {name = "withgraphite/tap";}
    ];
    brews = [
      "withgraphite/tap/graphite"
    ];
  };
}
