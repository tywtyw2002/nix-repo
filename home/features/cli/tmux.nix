{ config
, options
, pkgs
, lib
, ...
}:
let
  cfg = config.cli.tmux;
  cdotEnable = config.cdot.enable;
in
{
  options.cli.tmux = lib.mkEnableOption "cli.tmux" // { default = true; };

  config = lib.mkMerge (
    [
      {
        programs.tmux = {
          enable = cfg && !cdotEnable;
        };
      }

      (lib.mkIf cdotEnable {
        home.packages = [
          pkgs.tmux
        ];
      })
    ]
  );
}
