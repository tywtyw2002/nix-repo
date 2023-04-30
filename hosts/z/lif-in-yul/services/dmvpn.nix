{ config
, ...
}:
{
  services.dmvpn = {
    enable = true;
    broadcast = "10.100.0.255";
    ipCidr = "10.100.0.111/24";
    greKey = config.cVault.system.dmvpn.gre-key;
    ikeKey = config.cVault.system.dmvpn.ike-secret;
    register = {
      ipCidr = "10.100.0.1/24";
      nbma = config.cVault.system.dmvpn.hub-address;
    };
    authKey = config.cVault.system.dmvpn.auth-key;
  };
}
