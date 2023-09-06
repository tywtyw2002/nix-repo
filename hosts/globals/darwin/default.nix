{ lib
, inputs
, outputs
, system
, ...
}: {
  imports = [
    ./nix.nix
    ./brew.nix
  ];
  # ++ (builtins.attrValues outputs.nixosModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
    hostPlatform = system;
  };

  system.stateVersion = 4;

  services.nix-daemon.enable = true;
  # networking.domain = "c70.us";
  # networking.search = [ "c70.us" ];
}
