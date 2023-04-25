{ outputs
, lib
, config
, ...
}:
let
  hosts = outputs.nixosConfigurations;
  hostname = config.networking.hostName;
  pubKey = host: ../z/${host}/ssh_host_ed25519_key.pub;
  # pubKey =
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkDefault "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };

    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    # Each hosts public key
    knownHosts =
      builtins.mapAttrs
        (name: _: {
          publicKeyFile = pubKey name;
          extraHostNames = lib.optional (name == hostname) "localhost";
        })
        (lib.filterAttrs (n: v: !lib.hasPrefix "lxc" n) hosts);
  };

  security.pam.enableSSHAgentAuth = true;
}
