{ config, pkgs, ... }:

{
  imports = [
    ./modules
    ./home-manager/nixos/default.nix
    #"./configuration/hosts/${config.networking.hostName}"
  ];

  nixpkgs.overlays = [
    (self: super: import ./pkgs { inherit super; })
  ];
}
