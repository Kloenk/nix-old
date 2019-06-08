{ system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }, ... }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    rifo = callPackage ./rifo { };
    pytradfri = callPackage ./pytradfri { buildPythonPackage = pkgs.python37Packages.buildPythonPackage; fetchPypi = pkgs.python37Packages.fetchPypi; cython = pkgs.python37Packages.cython; };
    aiocoap = callPackage ./aiocoap { buildPythonPackage = pkgs.python37Packages.buildPythonPackage; fetchPypi = pkgs.python37Packages.fetchPypi; cython = pkgs.python37Packages.cython; };
  };

in newpkgs
