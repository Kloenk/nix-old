{ config, pkgs, ... }:

let
  secrets = import /etc/nixos/secrets.nix;

in {
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
        configuration.github.clientID = secrets.codi.github.id;
        configuration.github.clientSecret = secrets.codi.github.secret;
    };

    services.nginx.virtualHosts."codi.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:3001";
    };
}