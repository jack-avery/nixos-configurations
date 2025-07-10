{
  description = "my nixos stations configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixGL.url = "github:nix-community/nixGL";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixGL,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [nixGL.overlay];
    };
  in {
    nixosConfigurations = {
      nixdesk = nixpkgs.lib.nixosSystem {
        modules = [
          ./systems/modules/fonts.nix
          ./systems/nixdesk/configuration.nix
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

          ./homes/modules/themes/adwaita-gruvbox.nix

          ./homes/jack.nix
        ];
      };
    };
  };
}
