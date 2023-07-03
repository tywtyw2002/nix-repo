{ inputs
, outputs
, ...
}:
let
  sys = "x86_64-linux";
  rootPath = toString ../.;
  inherit (inputs.nixpkgs) lib;
  recursiveMerge = attrList:
    with lib; let
      f = attrPath:
        zipAttrsWith (
          n: values:
            if tail values == [ ]
            then head values
            # else if all isList values
            #   # then unique (concatLists values)
            #   then values
            else if all isAttrs values
            then f (attrPath ++ [ n ]) values
            else last values
        );
    in
    f [ ] attrList;
in
rec
{
  mkImport = path: override: attrs @ { config, ... }: recursiveMerge [ (import path { inherit config; }) override ];

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
