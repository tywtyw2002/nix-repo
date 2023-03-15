{ inputs
, outputs
, ...
}:
let
  sys = "x86_64-linux";
  rootPath = toString ../.;
in
rec
{
  mkImport = path: override: attrs @ { config, ... }: import path { inherit config; } // override;

  # mkHome = path: attrs @ { defaultSystem ? sys
  #                , override ? { }
  #                , ...
  #                }:
  mkHome = path: override @ { defaultSystem ? sys, ... }:
    let
      inherit (inputs.home-manager.lib) homeManagerConfiguration;
      pkgs = inputs.nixpkgs.legacyPackages.${defaultSystem};
      # realPath = toString path;
    in
    homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = { inherit inputs outputs; };
      modules = [
        "${rootPath}/home"
        (mkImport path override)
      ];
    };

  # rootPath = toString ../.;
}
