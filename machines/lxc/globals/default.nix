{ lib
, inputs
, outputs
, modulesPath
, ...
}:
{
  imports =
    [
      (modulesPath + "/virtualisation/proxmox-lxc.nix")
      ./nix.nix
    ] ++ (builtins.attrValues outputs.nixosModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  networking.firewall.enable = false;

  environment.noXlibs = true;
  documentation.enable = false;
  documentation.nixos.enable = false;
}