{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.zerotierone;

  mapOption = v:
    if v
    then "1"
    else "0";

  buildNetwork = name: values: let
    netId =
      if values.networkId != null
      then values.networkId
      else if values.networkIdFile != null
      then fileContents values.networkIdFile
      else name;
    netConfig = concatStringsSep "\n" (mapAttrsToList (n: v: "${n}=${mapOption v}") (filterAttrs (n: v: hasPrefix "allow" n) values));
  in
    assert ! (hasPrefix "zt-" netId); ''
      touch "/var/lib/zerotier-one/networks.d/${netId}.conf"
      if [[ ! -e "/var/lib/zerotier-one/networks.d/${netId}.local.conf" ]]; then
        echo "${netConfig}" > "/var/lib/zerotier-one/networks.d/${netId}.local.conf"
      fi
    '';
in {
  disabledModules = ["services/networking/zerotierone.nix"];
  options.services.zerotierone = {
    enable = mkEnableOption (lib.mdDoc "ZeroTierOne");
    userspace = mkOption {
      type = types.bool;
      default = false;
    };

    networks = mkOption {
      type = types.attrsOf (types.submodule ({name, ...}: {
        options = {
          networkId = mkOption {
            type = with types; nullOr str;
            default = null;
          };

          networkIdFile = mkOption {
            type = with types; nullOr str;
            default = null;
          };

          allowManaged = mkOption {
            type = types.bool;
            default = true;
            description = lib.mdDoc ''
              Allow ZeroTier to set IP Addresses and Routes ( local/private ranges only)
            '';
          };

          allowGlobal = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Allow ZeroTier to set Global/Public/Not-Private range IPs and Routes.
            '';
          };

          allowDefault = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Allow ZeroTier to set the Default Route on the system.
            '';
          };

          allowDNS = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Allow ZeroTier to set DNS servers.
            '';
          };
        };
      }));

      default = {};
    };

    port = mkOption {
      default = 9993;
      type = types.port;
      description = lib.mdDoc ''
        Network port used by ZeroTier.
      '';
    };

    package = mkOption {
      default = pkgs.zerotierone;
      defaultText = literalExpression "pkgs.zerotierone";
      type = types.package;
      description = lib.mdDoc ''
        ZeroTier One package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.zerotierone = {
      description = "ZeroTierOne";

      wantedBy = ["multi-user.target"];
      after = ["network.target" "sops-nix.service"];
      wants = ["network-online.target"];

      path = [cfg.package];

      preStart =
        ''
          mkdir -p /var/lib/zerotier-one/networks.d
          chmod 700 /var/lib/zerotier-one
          chown -R root:root /var/lib/zerotier-one
        ''
        + concatStringsSep "\n" (mapAttrsToList buildNetwork cfg.networks);
      serviceConfig = let
        userspace = optionalString cfg.userspace "-U";
      in {
        ExecStart = "${cfg.package}/bin/zerotier-one ${userspace} -p${toString cfg.port}";
        Restart = "always";
        KillMode = "process";
        TimeoutStopSec = 5;
      };
    };

    # ZeroTier does not issue DHCP leases, but some strangers might...
    networking.dhcpcd.denyInterfaces = ["zt*"];

    # ZeroTier receives UDP transmissions
    networking.firewall.allowedUDPPorts = [cfg.port];

    environment.systemPackages = [cfg.package];

    # Prevent systemd from potentially changing the MAC address
    systemd.network.links."50-zerotier" = {
      matchConfig = {
        OriginalName = "zt*";
      };
      linkConfig = {
        AutoNegotiation = false;
        MACAddressPolicy = "none";
      };
    };
  };
}
