{ config
, options
, pkgs
, lib
, ...
}:
let
  cfg = config.cli.basic;
in
{
  options.cli.basic = lib.mkEnableOption "cli.basic" // { default = true; };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      zsh

      rsync
      unzip
      p7zip

      patch

      curlFull
      coreutils-full
    ];
  };
}
