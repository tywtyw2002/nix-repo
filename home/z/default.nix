{ inputs
, outputs
, ...
}:
let
  inherit (import "${outputs.rootPath}/utils/hm.nix" { inherit inputs outputs; }) mkHome;
in
{
  "tyw@default" = mkHome ./tyw.nix { };
}
