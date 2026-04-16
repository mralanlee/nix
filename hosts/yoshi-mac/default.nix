{
  imports = [
    ../../os/darwin
  ];

  networking.hostName = "yoshi-mac";

  homebrew = {
    taps = [
      {name = "withgraphite/tap";}
    ];
    brews = [
      "withgraphite/tap/graphite"
    ];
  };
}
