{ pkgs, ... }:

{
      virtualisation.docker.enable = true;
      users.users.kloenk.extraGroups = [ "docker" ];
      users.users.kloenk.packages = [ pkgs.docker ];
}