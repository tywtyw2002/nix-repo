{
    imports = [
        ../../globals
        ./unifi.nix
    ];

    services.unifi.enable = true;

    system.stateVersion = "22.11";
}