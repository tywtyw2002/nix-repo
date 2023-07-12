{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.tailscale;
  isNetworkd = config.networking.useNetworkd;
in {
  disabledModules = ["services/networking/tailscale.nix"];

  options.services.tailscale = {
    enable = mkEnableOption (lib.mdDoc "Tailscale client daemon");

    port = mkOption {
      type = types.port;
      default = 41641;
      description = lib.mdDoc "The port to listen on for tunnel traffic (0=autoselect).";
    };

    interfaceName = mkOption {
      type = types.str;
      default = "tailscale0";
      description = lib.mdDoc ''The interface name for tunnel traffic. Use "userspace-networking" (beta) to not use TUN.'';
    };

    mtu = mkOption {
      type = types.int;
      default = 1420;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.tailscale]; # for the CLI
    systemd.packages = [pkgs.tailscale];
    systemd.services.tailscaled = {
      wantedBy = ["multi-user.target"];
      path = [
        # config.networking.resolvconf.package # for configuring DNS in some configs
        # pkgs.procps     # for collecting running services (opt-in feature)
        pkgs.glibc # for `getent` to look up user shells
      ];
      serviceConfig.Environment = [
        "PORT=${toString cfg.port}"
        "TS_DEBUG_MTU=${toString cfg.mtu}"
        "TS_NO_LOGS_NO_SUPPORT=true"
        ''"FLAGS=--tun ${lib.escapeShellArg cfg.interfaceName}"''
      ];
      # Restart tailscaled with a single `systemctl restart` at the
      # end of activation, rather than a `stop` followed by a later
      # `start`. Activation over Tailscale can hang for tens of
      # seconds in the stop+start setup, if the activation script has
      # a significant delay between the stop and start phases
      # (e.g. script blocked on another unit with a slow shutdown).
      #
      # Tailscale is aware of the correctness tradeoff involved, and
      # already makes its upstream systemd unit robust against unit
      # version mismatches on restart for compatibility with other
      # linux distros.
      stopIfChanged = false;
    };

    networking.dhcpcd.denyInterfaces = [cfg.interfaceName];

    systemd.network.networks."50-tailscale" = mkIf isNetworkd {
      matchConfig = {
        Name = cfg.interfaceName;
      };
      linkConfig = {
        Unmanaged = true;
        ActivationPolicy = "manual";
      };
    };
  };
}
