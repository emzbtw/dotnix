{
  description = "dotnix: single-machine NixOS flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    concord = {
      url = "github:chojs23/concord/v2.6.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flick = {
      url = "git+ssh://git@github.com/emzbtw/flick";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Seerr 3.4.1. Remove once nixflix supports the Seerr 3.5.0 library API (nixflix#385).
    nixpkgs-seerr.url = "github:nixos/nixpkgs/fe13242281a67641c0102cdb1087f0ebe586c7df";
    reel.url = "git+file:///home/emz/Projects/reel";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umbriel = {
      url = "git+https://github.com/noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vidicon = {
      url = "github:emzbtw/vidicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    voxtype = {
      url = "github:peteonrails/voxtype/v1.1.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdg-desktop-portal-umbriel = {
      url = "github:noctalia-dev/xdg-desktop-portal-umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flick,
    nix-index-database,
    nixflix,
    sops-nix,
    spicetify-nix,
    umbriel,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        flick.nixosModules.default
        nix-index-database.nixosModules.default
        nixflix.nixosModules.default
        sops-nix.nixosModules.sops
        spicetify-nix.nixosModules.default
        umbriel.nixosModules.default
      ];
    };
  };
}
