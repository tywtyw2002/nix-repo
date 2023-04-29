{ inputs
, outputs
, ...
}:
with inputs.nixpkgs.lib;
let
  mkContainer = path:
    nixosSystem {
      # inherit system;
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs; };
      modules = [
        (import path)
      ];
    };
in
{
  lxc_unifi = mkContainer ./unifi;
}
