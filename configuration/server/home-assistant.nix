{ pkgs, ... }:

{

    services.home-assistant.enable = true;
    services.home-assistant.package = pkgs.home-assistant.override {
        extraPackages = ps: [ ps.colorlog pkgs.pytradfri ];
    };
    services.home-assistant.configWritable = true;

    networking.firewall.allowedTCPPorts = [ 8123 ];
}