{
  imports = [
    ./hardware-configuration.nix
    ./services

    ../../globals
    ../../optionals/pkgs/basic.nix
    ../../optionals/services/dmvpn
    ../../optionals/services/fail2ban.nix

    ../../users/tyw.nix
    ../../users/root.nix
  ];

  homeOverride = {
    cli.dev.langs = [ "rust" ];
  };

  services.openssh.settings.PermitRootLogin = "yes";

  networking = {
    useDHCP = true;
  };

  programs.zsh.enable = true;

  system.stateVersion = "23.05";
}
