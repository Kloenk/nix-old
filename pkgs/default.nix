{ system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }, ... }:

let
  lib = pkgs.lib;
  callPackage = lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    collectd-wireguard = callPackage ./collectd-wireguard { };
    rifo = callPackage ./rifo { };
    rwm = callPackage ./rwm { };
    dwm = callPackage ./dwm { rwm = newpkgs.rwm; };
    slstatus = callPackage ./slstatus { };
    ftb = callPackage ./ftb { libXxf86vm = pkgs.xorg.libXxf86vm; };
    groupmanagement-bot = callPackage ./Groupmanagement-Bot {};
    #flameshot = pkgs.libsForQt5.callPackage ./flameshot { };
    #llgCompanion = callPackage ./llgCompanion { };
    #shelfie = callPackage ./shelfie { };
    pytradfri = callPackage ./pytradfri { buildPythonPackage = pkgs.python37Packages.buildPythonPackage; fetchPypi = pkgs.python37Packages.fetchPypi; cython = pkgs.python37Packages.cython; };
    aiocoap = callPackage ./aiocoap { buildPythonPackage = pkgs.python37Packages.buildPythonPackage; fetchPypi = pkgs.python37Packages.fetchPypi; cython = pkgs.python37Packages.cython; };
    netbox = pkgs.python37Packages.callPackage ./netbox { };
    inherit (callPackage ./minecraft-server { })
      minecraft-server_1_14_2;
      
  };

in newpkgs
