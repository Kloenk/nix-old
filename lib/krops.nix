let
  hosts = import ../configuration/hosts;

  krops = fetchGit {
    url = "https://github.com/krebs/krops/";
    ref = "v1.18.1";
  };

  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" {};

  mkSource = name: host: lib.evalSource [{
    configuration.file = toString ../configuration;
    modules.file = toString ../modules;
    pkgs.file = toString ../pkgs;
    sources.file = toString ../sources;
    secrets.pass = {
      dir = toString ../secrets;
      inherit name;
    };
    nixos-config.file = toString (pkgs.writeText "nixos-config" ''
      import <configuration/hosts/${name}/configuration.nix>
    '');
    nixpkgs.symlink = "sources/nixpkgs";
  }];
in
  lib.mapAttrs (name: host: pkgs.krops.writeDeploy "deploy" {
    source = mkSource name host;
    target = lib.mkTarget host.hostname // {
      sudo = true;
    };
  }) hosts
