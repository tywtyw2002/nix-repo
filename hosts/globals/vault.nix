{
  lib,
  options,
  config,
  ...
}:
with lib; let
  loadVault = fpath:
    if (builtins.pathExists fpath)
    then (builtins.fromTOML (builtins.readFile fpath))
    else {};
in {
  options.cVault = {
    system = with lib;
      mkOption {
        type = with types; attrs;
        default = {};
      };

    host = with lib;
      mkOption {
        type = with types; attrs;
        default = {};
      };
  };

  config.cVault = {
    system = loadVault ../secrets.toml;
    host = loadVault ../z/${config.networking.hostName}/secrets.toml;
  };
}
