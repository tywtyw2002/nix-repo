{ inputs
, outputs
, ...
}:
with inputs.nixos-generators; let
  mkContainer = path:
    nixosGenerate {
      # inherit system;
      system = "x86_64-linux";
      format = "proxmox-lxc";
      specialArgs = { inherit inputs outputs; };
      modules = [
        (import path)
      ];
    };
in
{
  unifi = mkContainer ./unifi;
}
