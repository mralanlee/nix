{
  imports = [
    ../common
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./home.nix
    ./nix.nix
  ];

  home = {
    username = "alan";
    homeDirectory = "/home/alan";
    stateVersion = "25.05";
  };
}
