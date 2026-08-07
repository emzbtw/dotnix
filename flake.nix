{
  description = "My NixOS flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-flatpak,
    spicetify-nix,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        nix-flatpak.nixosModules.nix-flatpak
        spicetify-nix.nixosModules.default
      ];
    };
  };
}
