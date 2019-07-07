{ config, ... }:

{
  services.deluge2 = {
    enable = true;
    configureNginx = true;
    downloadsBasicAuthFile = "/etc/nixos/secrets/downloadsBasicAuthFile.deluge";
    web.enable = true;
  };

  services.nginx.virtualHosts."kloenk.de" = {
    enableACME = true;
    forceSSL = true;
  };

  systemd.services.deluge-init = {
    script = ''
      mkdir -p /data/deluge
      chown deluge:deluge /data/deluge
      [ -e /var/lib/deluge ] || ln -s /data/deluge /var/lib/deluge
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    after = [ "network.target" ];
    before = [ "deluged.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  networking.firewall.allowedTCPPorts = [ 58846 60000 ];
  networking.firewall.allowedUDPPorts = [ 60000 ];
}