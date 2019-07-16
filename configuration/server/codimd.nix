{ config, pkgs, ... }:

{
    services.codimd = {
        enable = true;
        workDir = /data/codimd;
        configuration.port = 3001;
        configuration.path = "/var/run/codimd.sock";
        configuration.domain = "codi.kloenk.de";
        configuration.db = {
            dialect = "sqlite";
            storage = "/data/codimd/db.codimd.sqlite";
        };
    };
}