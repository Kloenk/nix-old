{ config, ... }:

{
	services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.nginx.enable = true;
  services.nginx.statusPage = true;
  services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de" = {
    locations."/node-exporter/metrics".proxyPass = "http://127.0.0.1:9100/metrics";
    locations."/node-exporter/metrics".extraConfig = ''
      allow 2001:41d0:1004:1629:1337:187:1:0/112;
      allow ::1/128;
      allow 51.254.249.187/32;
      allow 192.168.42.0/24;
      allow 127.0.0.0/8;
      deny all;
    '';
    locations."/nginx-exporter/metrics".proxyPass = "http://127.0.0.1:9113/metrics";
    locations."/nginx-exporter/metrics".extraConfig = config.services.nginx.virtualHosts."${config.networking.hostName}.kloenk.de".locations."/node-exporter/metrics".extraConfig;
  };
}
