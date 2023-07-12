{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./globals
    ./modules/cDot
    ./features/cli
  ];
}
