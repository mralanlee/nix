{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # macos
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    aerospace-tap = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    sops-nix,
    home-manager,
    zen-browser,
    darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    mac-app-util,
    aerospace-tap,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  in rec {
    formatter = forAllSystems (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );

    nixosConfigurations = {
      shimmer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
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
            home-manager.extraSpecialArgs = {
              inherit inputs;
              system = "x86_64-linux";
              myConfig = {
                tmux.enable = true;
              };
            };
          }
        ];
      };

      yoshi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./os/ubuntu
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alan.imports = [
              ./home/alan/ubuntu
            ];
            home-manager.extraSpecialArgs = {
              inherit inputs;
              system = "x86_64-linux";
              myConfig = {
                tmux.enable = true;
              };
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      drumwave = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/drumwave
          # sops-nix.nixosModules.sops
          home-manager.darwinModules.home-manager
          mac-app-util.darwinModules.default
          {
            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
          }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alan = import ./home/alan/darwin;
            home-manager.extraSpecialArgs = {
              myConfig = {
                tmux.enable = true;
              };
            };
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;

              user = "alan";
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "nikitabobko/tap" = aerospace-tap;
              };
            };
          }
        ];
      };
    };
  };
}
