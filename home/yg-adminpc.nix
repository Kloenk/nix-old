{
    pkgs, lib, ...
}:

let
  manager = import ../configuration/manager { pkgs = pkgs; dwm = true; };
in {
  nixpkgs.overlays = [
    (self: super: import ../pkgs { inherit super; })
  ];

  programs = manager.programs;

  services = manager.services;

  home = manager.home;

  xsession = manager.xsession;
}