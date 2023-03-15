{ pkgs, config, lib, inputs, outputs, ... }:
let
  inherit (import "${outputs.rootPath}/utils/hm.nix" {inherit inputs outputs;}) mkImport;
in
{
  users.users.tyw = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsrq4tWVEnf9SF4wqEtTgnkfY1sKbJEFDlqfuyJR6kJ tyw@CosHiM-MAC"
    ];
    passwordFile = config.sops.secrets.tyw-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.tyw-password = {
    sopsFile = "${outputs.rootPath}/hosts/secrets.yaml";
    neededForUsers = true;
  };

  home-manager.users.tyw = (mkImport "${outputs.rootPath}/home/z/tyw.nix" config.homeOverride);
}
