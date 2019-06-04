{ ... }:

{

    services.home-assistant.enable = true;
    services.home-assistant.package = pkgs.home-assistant.override {
        extraPackages = ps: with ps; [ colorlog ];
        skipPip = false;
    }
    services.home-assistant.configWritable = true;

    networking.firewall.allowedTCPPorts = [ 8123 ];
}