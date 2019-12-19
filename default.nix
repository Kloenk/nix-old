let
  hosts = import ./configuration/hosts;
  pkgs = import ./sources/nixpkgs { };
in {
  deploy = import ./lib/krops.nix;
  # kexec_tarbal
  # isoImage
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