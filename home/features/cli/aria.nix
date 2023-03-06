{ config
, options
, pkgs
, lib
, ...
}: with lib;
let
  cfg = config.cli.aria2;
in
{
  options.cli.aria2 = {
    enable = lib.mkEnableOption "cli.aria2";
    downloadPath = lib.mkOption {
      type = types.str;
      default = "~/Downloads";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.aria2 = {
      enable = true;
      settings = {
        dir = cfg.downloadPath;

        enable-rpc = true;
        rpc-allow-origin-all = true;
        rpc-listen-all = true;

        check-integrity = true;
        check-certificate = false;

        file-allocation = "prealloc"; # Assume ext4, this is faster there
        max-concurrent-downloads = 5;
        max-connection-per-server = 10;
        min-split-size = "10M";
        continue = true;
        split = 16;
      };
    };
  };
}
