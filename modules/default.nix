{ ... }:

{
  imports = [
    ./llgCompanion.nix
    ./deluge.nix
    ./collectd.nix
    ./ferm2
    ./secrets
    ./engelsystem
  ];
}
