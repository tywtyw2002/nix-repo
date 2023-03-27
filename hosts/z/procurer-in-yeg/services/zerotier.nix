{
    config,
    ...
}:

{
    services.zerotierone.enable = true;
    services.zerotierone.networks = {
        "zt-net-core" = {
            # networkIdFile = config.sops.secrets."zt-net-core".path;
            networkId = config.cVault.system.zerotier.zt-net-core;
            allowGlobal = true;
        };
    };
}