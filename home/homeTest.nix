{ config, pkgs, ... }:

{
  imports = [
    <sops-nix/modules/home-manager/sops.nix>
    ./.
  ];

  home.username = "debian";

  cdot.enable = true;
  cnvim.enable = true;
  cli.nix = true;
  cli.dev.langs = ["lua" "rust"];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.age-key.txt";
    secrets.cdot_github_token = {
      sopsFile = ./secrets.yaml;
    };
  };
}
