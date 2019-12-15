{ config, pkgs, ... }:

{
  imports = [
    ./modules
    ./home-manager/nixos/default.nix
  ];

  nixpkgs.overlays = [
    (self: super: import ./pkgs { inherit super; })
  ];
}
