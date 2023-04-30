{ config
, options
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.cli.git;
in
{
  options.cli.git = lib.mkOption {
    type = with types; attrsOf (oneOf [ bool float int str ]);
    default = { };
  };

  config.programs.git =
    {
      enable = true;
      userName = "Landon Wu";
      userEmail = "tywtyw2002@gmail.com";

      signing = {
        key = "CB77A3AB52E22C93CA8EC5D1F6CDC71FFDBE2EC3";
        signByDefault = true;
      };

      lfs.enable = true;

      ignores = [ ".direnv" ".DS_Store" ".Spotlight-V100" ".Trashes" ];
      extraConfig = {
        branch.autoSetupRebase = "always";
        checkout.defaultRemote = "origin";

        pull.rebase = true;
        pull.ff = "only";
        push.default = "current";

        init.defaultBranch = "master";
        submodule.recurse = "true";
      };
    }
    // cfg;
}
