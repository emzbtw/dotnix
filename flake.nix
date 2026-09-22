{
  description = "My NixOS flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
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
    reel.url = "git+file:///home/emz/code/projects/reel";
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
    # Imported by nixflix's own nixosModules.default; pinned to the rev in its
    # flake.lock so the module options it expects stay in sync.
    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement/a21f66ccd9f644c3770ccdf287cb380c00192628";
    xdg-desktop-portal-umbriel = {
      url = "github:noctalia-dev/xdg-desktop-portal-umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-flatpak,
    flick,
    nix-index-database,
    nixflix,
    sops-nix,
    spicetify-nix,
    umbriel,
    vpn-confinement,
    ...
  } @ inputs: let
    # nixflix's source tree with patches/ applied, so a patched module can be
    # imported in place of nixflix.nixosModules.default (which imports the
    # unpatched sources plus the vpn-confinement module mirrored below).
    nixflixPatched = nixpkgs.legacyPackages.x86_64-linux.applyPatches {
      name = "nixflix-patched";
      src = nixflix.outPath;
      patches = [./patches/nixflix-allowed-hosts.patch];
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        nix-flatpak.nixosModules.nix-flatpak
        flick.nixosModules.default
        nix-index-database.nixosModules.default
        (import (nixflixPatched + "/modules"))
        vpn-confinement.nixosModules.default
        sops-nix.nixosModules.sops
        spicetify-nix.nixosModules.default
        umbriel.nixosModules.default
      ];
    };
  };
}
