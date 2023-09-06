{ inputs
, outputs
, ...
}:
let
  mkDarwin = with inputs.nix-darwin.lib;
    path: { darwin_users ? [ "tyw" ]
          , system ? "x86_64-darwin"
          , ...
          }:
      darwinSystem {
        specialArgs = { inherit inputs outputs darwin_users system; };
        modules = [
          # {
          #   nix.settings.trusted-users = darwin_users;
          # }
          (import path)
        ];
      };
in
{
  cmac = mkDarwin ./cmac { };
}
