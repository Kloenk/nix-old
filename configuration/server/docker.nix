{ pkgs, ... }:

{
  networking.firewall.interface."docker0" = {
    allowedTCPPortRanges = [ { from = 1; to = 65534; } ];
    allowedUDPPortRanges = [ { from = 1; to = 65534; } ];
  };

  virtualisation.docker.enable = true;
  users.users.kloenk.extraGroups = [ "docker" ];
  users.users.kloenk.packages = [ pkgs.docker ];
}

