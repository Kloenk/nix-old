{ config, pkgs, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
    services.prometheus = {
        enable = true;

        exporters = {
        };

        scrapeConfigs = [
            {
                job_name = "nginx";
                static_configs = [{ targets = [ "127.0.0.1:9113" ] ; } ];
            }
        ];
    };

    services.grafana = {
        enable = true;

        port = 3002;

        analytics.reporting.enable = false;
        rootUrl = "https://grafana.kloenk.de/";
        security.secretKey = secrets.grafana.signingKey;
        security.adminUser = "kloenk";
        security.adminPassword = secrets.grafana.adminPassword;

        database = {
            type = "postgres";
            host = "127.0.0.1:5432";
            user = "grafana";
            password = secrets.postgres.grafana;
        };

        smtp = {
            enable = true;
            fromAddress = "grafana@kloenk.de";
            user = "grafana@kloenk.de";
            password = secrets.grafana.mailPassword;
        };
    };

    systemd.services.grafana.after = [ "postgresql.service" ];

    services.nginx.virtualHost."grafana.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:3002";
    };
}