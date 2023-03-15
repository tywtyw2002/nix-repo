{ config
, options
, pkgs
, lib
, ...
}:
let
  cfg = config.cli.starship;
  cdotEnable = config.cdot.enable;
in
{
  options.cli.starship = lib.mkEnableOption "cli.starship";

  config = lib.mkMerge (
    let
      starship-c = pkgs.starship-c;
    in
    [
      {
        programs.starship = {
          package = starship-c;
          enable = cfg && !cdotEnable;
          enableIonIntegration = false;
          enableNushellIntegration = false;
        };
      }

      (lib.mkIf cdotEnable {
        home.packages = [
          starship-c
        ];
      })
    ]
  );
}
