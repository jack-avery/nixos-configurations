{
  description = "my nixos stations configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixGL.url = "github:nix-community/nixGL";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixGL,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        nixGL.overlay
      ];
    };
  in {
    nixosConfigurations = {
      ra = nixpkgs.lib.nixosSystem {
        modules = [
          ./systems/modules/fonts.nix
          ./systems/ra/configuration.nix

          {
            nixpkgs.overlays = [
              (self: super: {
                gale = nixpkgs-unstable.legacyPackages.x86_64-linux.gale;
              })
            ];
          }
        ];
      };
    };

    homeConfigurations = {
      jack = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./homes/modules/programs/alacritty.nix
          ./homes/modules/programs/bash.nix
          ./homes/modules/programs/git.nix
          ./homes/modules/programs/nvim.nix
          ./homes/modules/programs/vscodium.nix

          ./homes/modules/themes/breeze-gruvbox.nix

          ./homes/jack.nix
        ];
      };

      # my work laptop is mint using ubuntu. use adwaita-gruvbox instead
      jack-workbook = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./homes/modules/programs/alacritty.nix
          ./homes/modules/programs/bash.nix
          ./homes/modules/programs/git.nix
          ./homes/modules/programs/nvim.nix
          ./homes/modules/programs/vscodium.nix

          ./homes/modules/themes/adwaita-gruvbox.nix

          ./homes/jack.nix
        ];
      };
    };
  };
}
