{ config
, options
, pkgs
, lib
, cdot_scripts
, ...
}:
with lib; let
  cfg = config.cdot;
in
{
  options.cdot = {
    root = mkOption {
      type = types.str;
      default = ".cdot";
    };

    enable = mkEnableOption "cdot";
  };

  config = mkIf cfg.enable {
    home.activation.cDotCloner = lib.hm.dag.entryAfter [ "reloadSystemd" "onFilesChange" ] ''
      cloneHttpsRepo="https://github.com/tywtyw2002/coshim.dot.git"
      GIT_FULL_REPO="git@github.com:tywtyw2002/coshim.dot.git"
      GIT_BRANCH="master"

      if [ ! -d "$HOME/${cfg.root}" ]; then
        ${pkgs.git}/bin/git -C $HOME clone $cloneHttpsRepo --recurse-submodules --branch $GIT_BRANCH ${cfg.root}
        ${pkgs.git}/bin/git -C $HOME/${cfg.root} remote set-url origin $GIT_FULL_REPO
      fi
    '';
  };
}
