{
    pkgs, ...
}:

let
  manager = import ./configuration/manager { pkgs = pkgs; };
in {
  nixpkgs.overlays = [
    (self: super: import ./pkgs { inherit super; })
  ];

  programs = manager.programs;

  services = manager.services;
}