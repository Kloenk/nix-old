{ config, pkgs, ... }:

{
    services.codimd = {
        enable = true;
        workDir = "/data/codimd/";
        configuration.port = 3001;
        configuration.domain = "codi.kloenk.de";
        configuration.protocolUseSSL = true;
        configuration.db = {
            dialect = "sqlite";
            storage = "/data/codimd/db.codimd.sqlite";
        };
    };

    services.nginx.virtualHosts."codi.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:3001";
    };
}