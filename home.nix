{
    pkgs, ...
}:

let
  manager = import ./configuration/manager { };
in {
  programs = manager.programs;

  services = manager.services;
}