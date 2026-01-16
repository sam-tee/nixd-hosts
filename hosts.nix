inputs: {
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
}
