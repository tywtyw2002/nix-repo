{ config
, options
, pkgs
, lib
, ...
}:
let
  cfg = config.cli.nix;
in
{
  options.cli.nix = lib.mkEnableOption "cli.nix";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      nil
      nurl
      alejandra
      nixpkgs-fmt
      nix-prefetch

      # nix-diff
      # nix-du
      # nix-index
      nix-tree
    ];
  };
}
