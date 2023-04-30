{ config
, options
, pkgs
, lib
, ...
}:
let
  cfg = config.cli.rust_cli;
in
{
  options.cli.rust_cli =
    lib.mkEnableOption "cli.rust_cli"
    // {
      default = true;
    };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      bat
      bottom
      dog
      du-dust
      exa
      gitui
      fd
      procs
      ripgrep
      sd
      skim # fuzzy replacement
      zoxide
    ];
  };
}
