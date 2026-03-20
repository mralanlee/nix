{
  imports = [
    ../common
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./home.nix
    ./nix.nix
    ./ssh.nix
  ];

  home = {
    username = "alan";
    homeDirectory = "/home/alan";
    stateVersion = "25.05";
  };
}
