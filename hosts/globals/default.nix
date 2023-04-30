{ lib
, inputs
, outputs
, ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./nix.nix
      ./sops.nix
      ./locale.nix
      ./openssh.nix
      ./options.nix
      ./vault.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
    sharedModules = [ "${outputs.rootPath}/home" ];
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  networking.domain = "c70.us";
  networking.search = [ "c70.us" ];

  networking.firewall.enable = false;

  users.mutableUsers = lib.mkDefault false;
}
