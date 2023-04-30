{ inputs
, lib
, pkgs
, config
, outputs
, ...
}:
with lib; {
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = mkDefault "tyw";
    homeDirectory = mkDefault "/home/${config.home.username}";
    stateVersion = mkDefault "23.05";
  };
}
