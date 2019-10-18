{ config, pkgs, ... }:
 
let
  secrets = import /etc/nixos/secrets.nix;
in {
  home-manager.users.kloenk.services.spotifyd = {
    enable = true;
    user = "kloenk1";
    password = secrets.spotifyd;
    name = "${config.networking.hostName}_spotify";
    cache = "/home/kloenk/.cache/spotifyd";
    bitrate = 320;
  };
}