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
                static_configs = [ { targets = [ "127.0.0.1:9113" ] ; } ];
            }
            {
                job_name = "opentracker";
                static_configs = [ { targets = [
                  "127.0.0.1:9999"
                  "127.0.0.1:9998"
                ] ; } ];
            }
            {
                job_name = "collectd";
                static_configs = [ { targets = [
                    "127.0.0.1:9103"
                    "192.168.42.6:9103"
                    "192.168.42.7:9103"    
                ] ; } ];
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
            passwordFile = "/etc/nixos/secrets/grafana-mail.password";
        };
    };

    systemd.services.grafana.after = [ "postgresql.service" ];

    services.nginx.virtualHosts."grafana.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:3002";
    };
}
