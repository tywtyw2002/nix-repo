{ config
, options
, pkgs
, lib
, ...
}:
with lib; let
  # rust-overlay = import <rust-overlay> {};
  cfg = config.cli.dev;
  applyLangs = langs: finalConfig:
    finalConfig
    // listToAttrs (map
      (x: {
        name = x;
        value = true;
      })
      langs);
in
{
  options.cli.dev = {
    langs = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    python = mkEnableOption "cli.dev.python";
    lua = mkEnableOption "cli.dev.lua";
    rust = mkEnableOption "cli.dev.rust";
    c = mkEnableOption "cli.dev.c";
  };

  config =
    let
      devCfg = applyLangs cfg.langs cfg;
    in
    mkMerge [
      (mkIf devCfg.python {
        home.packages = with pkgs; [
          python311

          # pylsp
          pyright
          ruff

          pdm
        ];
      })

      (mkIf devCfg.lua {
        home.packages = with pkgs; [
          lua5_4_compat
          lua54Packages.luarocks

          stylua
        ];
      })

      (mkIf devCfg.rust {
        home.packages = with pkgs; [
          (rust-bin.selectLatestNightlyWith (toolchain: toolchain.minimal))
          # cargo

          rustfmt
          clippy

          rust-analyzer
        ];
      })

      (mkIf devCfg.c {
        home.packages = with pkgs; [
          gcc
          gnumake
          cmake
        ];
      })
    ];
}
