{
  imports = [
    ./hardware-configuration.nix

    ../../globals
    ../../optionals/pkgs/basic.nix
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
