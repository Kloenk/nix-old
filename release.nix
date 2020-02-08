{
	nix ? builtins.fetchGit ./.
, nixpkgs ? ./sources/nixpkgs
, officialRelease ? false
, systems ? [ "x86-64_linux" ]
, hostsFile ? ./configuration/hosts
, rootFile ? ./.
}:

let
  pkgs = import nixpkgs { system = builtins.currentSystem or "x86-64_linux"; };

  lib = pkgs.lib;

  hosts = import hostsFile;

  root = import rootFile;


  
  jobs = rec {
  	isoImage = root.isoImage;

  	#dep = let
  	#	makeDeploy = name: root.deploy."${name}";
  	#in {
  	#	makeDeploy hosts
  	#};


  	update-sources = root.update-sources;


  	#  config.system.build.toplevel 
  };
in jobs
