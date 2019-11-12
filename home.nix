{
    pkgs, ...
}:

let
  manager = import ./configuration/manager { pkgs = pkgs; };
in {
  programs = manager.programs;

  services = manager.services;
}