{
    services.fail2ban.enable = true;
    services.fail2ban.bantime = "24h";
    services.fail2ban.ignoreIP = [
        "10.100.0.0/24"
    ];
}