{ nixConfSrc ? { outPath = ./.; revCount = 1234; shortRev = "abcdef"; }
, nixpkgs ? builtins.fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-19.09.tar.gz
, officialRelease ? false
}:

let 
  pkgs = import nixpkgs { system = builtins.currentSystem or "x86_64-linux"; };

  jobs = rec {
    tarball = 
      pkgs.releaseTools.sourceTarball rec {
        name = "nixConf-tarball";
        version = "0.1.0" +
        (if officialRelease then "" else
          "." +
          ((if nixConfSrc ? lastModified
            then builtins.substring 0 8 nixConfSrc.lastModified
            else toString nixConfSrc.revCount or 0)
           + "." + nixConfSrc.shortRev));
        src = nixConfSrc;
        preAutoConf = "echo ${version} > version";
        postDist = ''
          cp README.md $out/
          echo "doc readme $out/README.md" >> $out/nix-support/hydra-build-products
        '';
      };

  };
in jobs
