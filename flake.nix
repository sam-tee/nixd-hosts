{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs @ {self, ...}: {
    darwinConfigurations."lsp" = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        {system.stateVersion = 6;}
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];
    };
    nixosConfigurations."lsp" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };
    homeConfigurations."lsp" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        inputs.plasma-manager.homeModules.plasma-manager
        {
          home = {
            stateVersion = "25.05";
            username = "lsp";
            homeDirectory = "/home/sam";
          };
        }
      ];
    };
  };
}
