{ pkgs ? import <nixpkgs> { } }: {
  starship-c = pkgs.callPackage ./starship-c { };
  strongswan = pkgs.callPackage ./strongswan { };
  opennhrp = pkgs.callPackage ./opennhrp { };
}
