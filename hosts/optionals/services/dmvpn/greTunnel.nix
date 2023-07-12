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
    interfaceName = mkOption {
      type = types.str;
      default = "dmvpn0";
      description = lib.mdDoc ''Ifname.'';
    };
    ttl = mkOption {
      type = types.int;
      default = 64;
      description = lib.mdDoc ''TTL'';
    };
    mtu = mkOption {
      type = types.int;
      default = 1376;
    };
    greLocal = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    broadcast = mkOption {
      type = types.str;
    };
    ipCidr = mkOption {
      type = types.str;
    };
    greKey = mkOption {
      type = types.int;
      description = lib.mdDoc ''greKey'';
    };
  };

  config = mkIf cfg.enable {
    systemd.services."${n}-netdev" = {
      enable = true;
      description = "DMVPN GRE Tunnel Interface ${n}";
      wantedBy = ["network-setup.service"];
      # bindsTo = deps;
      partOf = ["network-setup.service"];
      after = ["network-pre.target"];
      before = ["network-setup.service"];
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      path = [pkgs.iproute2];
      script = ''
        # Remove Dead Interfaces
        ip link show "${n}" >/dev/null 2>&1 \
          && ip link delete "${n}"
        ip link add name "${n}" type gre \
          ttl ${toString cfg.ttl} \
          key ${toString cfg.greKey} \
          ${optionalString (cfg.greLocal != null) "local \"${cfg.greLocal}\""}
        ip link set "${n}" up
        ip link set \
          mtu ${toString cfg.mtu} \
           multicast on \
           broadcast ${cfg.broadcast} \
          dev "${n}"
        ip addr add ${cfg.ipCidr} dev "${n}"
      '';
      postStop = ''
        ip link delete "${n}" || true
      '';
    };
  };
}
