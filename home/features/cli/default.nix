{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # groups
    ./z_basic.nix
    ./z_rust_cli.nix
    ./z_nix.nix
    ./z_utils.nix
    ./z_dev.nix

    ./aria.nix

    # ./bash.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix

    ./git.nix
    # ./gpg.nix
    # ./ssh.nix
  ];
}
