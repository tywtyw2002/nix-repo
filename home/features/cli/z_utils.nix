{ config, options, pkgs, lib, ... }:
let cfg = config.cli.utils;
in
{
  options.cli.utils = lib.mkEnableOption "cli.utils" // { default = true; };

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      neofetch

      fzf
      jq
      yq

      rage
      age-plugin-yubikey
      age

      htop
      iperf
      tcpdump
      openssl

      dnsutils
      httpie
      lazygit

      silver-searcher
    ];
  };
}
