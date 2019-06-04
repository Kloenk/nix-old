{ system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }, ... }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    rifo = callPackage ./rifo { };
    pytradfri = callPackage ./pytradfri { buildPythonPackage = python37Packages.buildPythonPackage; fetchPypi = python37Packages.fetchPypi; };
  };

in newpkgs
