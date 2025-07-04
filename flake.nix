{
  description = "my nixos stations configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixGL.url = "github:nix-community/nixGL";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixGL,
    ...
  }: let
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
          ./globals/all.nix
          ./systems/nixdesk/configuration.nix
        ];
      };
    };

    homeConfigurations."jack" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./homes/jack/home.nix
      ];
    };
  };
}
