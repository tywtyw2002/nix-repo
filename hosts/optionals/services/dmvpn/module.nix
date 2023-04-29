{ config
, lib
, pkgs
, ...
}:
with lib; {
  options.services.dmvpn = {
    enable = mkEnableOption (lib.mdDoc "dmvpn");
  };
}
