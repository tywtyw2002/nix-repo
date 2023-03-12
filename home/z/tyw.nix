{ inputs
, outputs
, config
, pkgs
, ...
}: {
  imports = [
    ../.
  ];

  home.username = "tyw";

  cdot.enable = true;
  cnvim.enable = true;
  cli.nix = true;
  cli.dev.langs = [ "lua" "rust" ];

  # cli.git.signing.signByDefault = false;

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.age-key.txt";
    secrets.cdot_github_token = {
      sopsFile = ../secrets.yaml;
    };
  };
}
