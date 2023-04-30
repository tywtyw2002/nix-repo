{ lib
, options
, ...
}: {
  options.homeOverride = with lib;
    mkOption {
      type = with types; attrs;
      default = { };
    };
}
