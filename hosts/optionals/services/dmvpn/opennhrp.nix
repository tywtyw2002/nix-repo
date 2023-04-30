{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.services.dmvpn;
  n = cfg.interfaceName;
  mkMapOption = { name, ... }: {
    options = {
      ipCidr = mkOption {
        type = types.str;
        default = null;
      };

      nbma = mkOption {
        type = types.str;
        default = null;
      };
    };
  };
  mapFormat = c: "map ${c.ipCidr} ${c.nbma}";
in
{
  options.services.dmvpn = {
    isHub = mkOption {
      type = types.bool;
      default = false;
    };

    register = mkOption {
      type = types.submodule mkMapOption;
      default = { };
    };

    maps = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };
    authKey = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = lib.mdDoc ''opennhrp authKey'';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (!isNull cfg.register.ipCidr) || cfg.isHub;
        message = "Opennhrp must set hub mode or config register info.";
      }
    ];
    environment.systemPackages = [ pkgs.opennhrp ]; # for the CLI
    systemd.packages = [ pkgs.opennhrp ];

    # opennhrp.conf
    environment.etc."opennhrp/opennhrp.conf".text =
      let
        body =
          [
            "holding-time 1800"
            "shortcut"
            "redirect"
            "non-caching"
            "multicast dynamic"
          ]
          ++ optionals (!cfg.isHub) [ "${mapFormat cfg.register} register" ]
          ++ optionals (!isNull cfg.authKey) [ "cisco-authentication ${toString cfg.authKey}" ]
          ++ optionals (!isNull cfg.maps) cfg.maps;
      in
      ''
        interface ${n}
          ${concatStringsSep "\n  " body}
      '';

    environment.etc."opennhrp/opennhrp-script".source = pkgs.substituteAll {
      src = ./opennhrp-script;
      ikeName = n;
      envPath = concatStringsSep ":" [ "${pkgs.iproute2}/bin" "${pkgs.strongswan}/bin" "${pkgs.gnugrep}/bin" ];
    };
    environment.etc."opennhrp/opennhrp-script".mode = "755";

    systemd.services.opennhrp = {
      enable = true;
      description = "DMVPN opennhrpd";
      # bindsTo = deps;
      # partOf = [ "network-setup.service" ];
      after = [ "network-online.target" "strongswan-swanctl.service" ];
      wantedBy = [ "multi-user.target" ];
      # before = [ "network-setup.service" ];
      # serviceConfig.Type = "oneshot";
      # serviceConfig.RemainAfterExit = true;
      restartTriggers = [ config.environment.etc."opennhrp/opennhrp.conf".source ];
      path = [ pkgs.iproute2 pkgs.strongswan ];
      serviceConfig = {
        ExecStart = "${pkgs.opennhrp}/sbin/opennhrp -d -c /etc/opennhrp/opennhrp.conf -s /etc/opennhrp/opennhrp-script";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Type = "forking";
      };
    };
  };
}
