{ inputs
, outputs
, ...
}:
let
  sys = "x86_64-linux";
  mkHome = path: attrs @ { defaultSystem ? sys, override ? {}, ... }:
    let
      inherit (inputs.home-manager.lib) homeManagerConfiguration;
      pkgs = inputs.nixpkgs.legacyPackages.${defaultSystem};
      cpkgs = outputs.packages.${defaultSystem};
    in
    homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = { inherit inputs outputs cpkgs; };
      modules = [
        (import path)
        override
      ];
    };
in
{
  "tyw@default" = mkHome ./tyw.nix { };
}
