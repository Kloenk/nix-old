{
	NixSrc ? builtins.fetchGit ./.
, nixpkgs ? builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
, officialRelease ? false
, systems ? [ "x86-64_linux" ]
}:

let
  pkgs = import nixpkgs { system = builtins.currentSystem or "x86-64_linux"; };

  lib = pkgs.lib;

  #hosts = import NixSrc + hostsFile;

  #root = import (toString NixSrc + toString rootFile);
  root = import ./default.nix;


  
  jobs = rec {
  	isoImage = root.isoImage;

  	# deploy scripts
    deploy = let
      targets = root.deploy;
    in targets;


  	update-sources = root.update-sources;


  	#  config.system.build.toplevel 
  };
in jobs
