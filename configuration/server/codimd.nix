{ config, pkgs, ... }:

{
    services.codimd = {
        enable = true;
        services.codimd.workDir = /data/codimd;
        configuration.port = 3001;
        configuration.path = "/var/run/codimd.sock";
        configuration.domain = "codi.kloenk.de";
    };
}