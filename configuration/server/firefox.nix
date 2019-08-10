{ config, ... }:

{
    services.firefox.syncserver = {
        enable = true;
        publicUrl = "https://firefox.kloenk.de";

    };

    services.nginx.virtualHosts."firefox.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:5000";
    };
}