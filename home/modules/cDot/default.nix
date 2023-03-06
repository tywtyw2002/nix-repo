{ config
, options
, pkgs
, lib
, ...
}:
with lib; {
  imports = [
    ./cdot.nix
    ./cnvim.nix
  ];
}
