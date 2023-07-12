{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cnvim;
  agebin = lib.getExe pkgs.rage;
in {
  options.cnvim = {
    root = mkOption {
      type = types.str;
      default = ".nvim";
    };

    enable = mkEnableOption "cnvim";
  };

  config = mkIf cfg.enable {
    home.activation.cNvimCloner = lib.hm.dag.entryAfter ["cDotCloner"] ''
      sops_token_path=${config.sops.secrets.cdot_github_token.path}
      if [ "''${sops_token_path:0:2}" == "%s" ]; then
        sops_token_path="$XDG_RUNTIME_DIR''${sops_token_path:2}"
        TOKEN=`cat $sops_token_path`
      fi
      NIX_AGE_KEY="$HOME/.age-key.txt"
      if [ -f "${./git_token.age}" ] && [ -f "$NIX_AGE_KEY" ]; then
        TOKEN=`cat ${./git_token.age} | ${agebin} -d -i $NIX_AGE_KEY`
      fi

      cloneHttpsRepo="https://$TOKEN@github.com/tywtyw2002/nvim.dot.git"
      GIT_FULL_REPO="git@github.com:tywtyw2002/nvim.dot.git"
      GIT_BRANCH="z/lazy-it"

      if [ ! -d "$HOME/${cfg.root}" ]; then
        ${pkgs.git}/bin/git -C $HOME clone $cloneHttpsRepo --recurse-submodules --branch $GIT_BRANCH ${cfg.root}
        ${pkgs.git}/bin/git -C $HOME/${cfg.root} remote set-url origin $GIT_FULL_REPO
      fi
    '';
  };
}
