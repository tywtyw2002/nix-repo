{
  description = "CosHiM NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;

      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
    in
    {
      # nixosModules = import ./modules;

      # overlays = import ./overlays { inherit inputs outputs; };
      overlays = {
        rust-overlay = inputs.rust-overlay.overlays.default;
      };

      formatter = forEachPkgs (pkgs: pkgs.nixpkgs-fmt);
      packages = forEachPkgs (pkgs: import ./pkgs { inherit pkgs; });
      # devShells = forEachPkgs (pkgs: import ./shell.nix { inherit pkgs; });

      # templates = import ./templates;

      # nixosConfigurations = import ./hosts/z
      # homeConfigurations = import ./home/z { inherit lib; };
      homeConfigurations = import ./home/z { inherit inputs outputs; };
    };
}