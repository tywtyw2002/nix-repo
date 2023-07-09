{ pkgs ? import <nixpkgs> { }
, rootPath ? ../.
,
}:
let
  pkg-utils = import "${rootPath}/utils/pkgs.nix" { inherit pkgs; };
in
{
  starship-c = pkgs.callPackage ./starship-c { };
  strongswan = pkgs.callPackage ./strongswan { };
  opennhrp = pkgs.callPackage ./opennhrp { };
  gost = pkgs.callPackage ./gost { };
  # wireproxy = pkgs.callPackage ./wireproxy { inherit pkg-utils; };
  wireproxy = pkg-utils.importTomlPkg { name = "wireproxy"; };
}
