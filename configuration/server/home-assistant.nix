{ ... }:

{

    services.home-assistant.enable = true;
    services.home-assistant.configWritable = true;

    networking.firewall.allowedTCPPorts = [ 8123 ];
}