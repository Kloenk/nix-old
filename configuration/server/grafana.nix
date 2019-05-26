{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 3000 ];
  services.grafana = {
      enable = true;
      addr = "0.0.0.0";
      domain = "10.0.2.15";
      rootUrl = "http://10.0.2.15/";
    };
}