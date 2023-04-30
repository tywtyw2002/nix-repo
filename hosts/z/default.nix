{ inputs
, outputs
, ...
}:
with inputs.nixpkgs.lib; let
  mkHost = path:
    nixosSystem {
      # inherit system;
      specialArgs = { inherit inputs outputs; };
      modules = [
        {
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (import path)
      ];
    };
in
{
  procurer-in-yeg = mkHost ./procurer-in-yeg;
  rokh-in-sea = mkHost ./rokh-in-sea;
  lif-in-yul = mkHost ./lif-in-yul;
}
