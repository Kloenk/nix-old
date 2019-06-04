{ system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }, ... }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    rifo = callPackage ./rifo { };
    pytradfri = callPackage ./pytradfri { python37Packages.buildPythonPackage };
  };

in newpkgs
