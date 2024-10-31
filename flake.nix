{
  description = "my nixos stations configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      nixdesk = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./globals/all.nix
          ./systems/nixdesk/configuration.nix
        ];
      };
    };

    homeConfigurations."jack" = home-manager.lib.homeManagerConfiguration {
      pkgs = (import nixpkgs) {inherit system;};
      modules = [./homes/jack/home.nix];
    };
  };
}
