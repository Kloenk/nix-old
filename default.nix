let
  hosts = import ./configuration/hosts;
  pkgs = import ./sources/nixpkgs { };
in {
  deploy = import ./lib/krops.nix;
  kexec_tarball = import ./lib/kexec-tarball.nix;
  isoImage = import ./lib/iso-image.nix;
  # pkgs = import ./configuration/pkgs;

  update-sources = pkgs.writeScript "update-sources" ''
    #!${pkgs.stdenv.shell}
    set -xe
    cd ${toString ./.}
    git submodule foreach git pull
    git add sources
    git commit -m "update submodules"
  '';
}
