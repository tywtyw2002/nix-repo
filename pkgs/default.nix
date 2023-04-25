{ pkgs ? import <nixpkgs> { } }: {
  starship-c = pkgs.callPackage ./starship-c { };
}
