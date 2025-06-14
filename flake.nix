{
  description = "my nixos stations configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    plasma-manager.url = "github:nix-community/plasma-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    plasma-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
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
        plasma-manager.homeManagerModules.plasma-manager
        ./homes/jack/home.nix
      ];
    };
  };
}
