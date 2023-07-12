{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.dmvpn;
  n = cfg.interfaceName;
in {
  options.services.dmvpn = {
    ikeKey = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.strongswan]; # for the CLI
    systemd.packages = [pkgs.strongswan];
    services.strongswan-swanctl = {
      enable = true;
      # connections
      swanctl.connections."${n}" = {
        proposals = [
          "aes256-sha1-modp1024"
          "3des-sha1-modp1024"
        ];
        version = 1;
        rekey_time = "86400s";
        keyingtries = 0;
        local.default.auth = "psk";
        remote.default.auth = "psk";

        children."${n}" = {
          esp_proposals = ["aes128-sha1-modp1024"];
          rekey_time = "3273s";
          rand_time = "540s";
          local_ts = ["dynamic[gre]"];
          remote_ts = ["dynamic[gre]"];
          mode = "transport";
        };
      };
      # ike secret
      swanctl.secrets.ike."${n}".secret = cfg.ikeKey;
    };
  };
}
