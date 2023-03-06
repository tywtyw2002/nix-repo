{ config, options, pkgs, lib, ... }:
let cfg = config.cli.nix;
in
{
  options.cli.nix = lib.mkEnableOption "cli.nix";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      nurl
      nixpkgs-fmt
      nix-prefetch
      rnix-lsp

      # nix-diff
      # nix-du
      # nix-index
    ];
  };
}
