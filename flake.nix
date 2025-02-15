{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix"; 
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { 
    self, 
    nixpkgs, 
    nixos-hardware,
    sops-nix,
    home-manager,
    ... 
  } @ inputs: let
   forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ]; 
  in rec {
    # packages = forAllSystems (
    #   system: let
    #     pkgs = nixpkgs.legacyPackages.${system};
    #   in
    #     import ./pkgs {inherit pkgs;}
    # );

    formatter = forAllSystems (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );

    nixosConfigurations = {
      shimmer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/shimmer
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alan.imports = [
                ./home/alan/nixos
            ]; # this will be nixos config
          }
        ];
      };
    };
  };
}
