{ config
, options
, pkgs
, lib
, ...
}: with lib;
let
  cfg = config.cli.zsh;
  cdotRoot = "$HOME/.config/zsh"; # config.cdot.root
  zshInitPath = "${cdotRoot}/${cfg.cdotZshInit}";
in
{
  options.cli.zsh = {
    cdotEnable = lib.mkEnableOption "zsh cdot cfg" // { default = true; };
    zshConfig = lib.mkOption {
      type = with types; attrsOf (oneOf [ bool float int str ]);
      default = { };
    };
    cdotZshInit = lib.mkOption {
      type = types.str;
      default = "zsh_init";
    };
    extraConfig = lib.mkOption {
      default = "";
      type = types.lines;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (!cfg.cdotEnable) {
      programs.zsh = {
        enable = true;
      } // cfg.zshConfig;
    })

    # config from cdot repo
    (lib.mkIf cfg.cdotEnable {
      home.packages = with pkgs; [ zsh ];

      programs.zsh.enable = false;

      home.file.".zshrc".text = concatStringsSep "\n" ([
        "setopt prompt_subst"
        "NIX_Z_CONFIG=${cdotRoot}"
        "NIX_ZGEN_PATH=$HOME/.local/zgen"
        "source ${zshInitPath}"
        cfg.extraConfig
      ]);
    })
  ];


}
