{ config, pkgs, ... }:

let
  secrets = import <secrets/grafana.nix>;
in {
    services.prometheus = {
        enable = true;
        
        globalConfig.scrape_interval = "10s";

        exporters = {
        };

        scrapeConfigs = [
            {
                job_name = "grafana";
                static_configs = [ { targets = [
                  "127.0.0.1:3002"
                ] ; } ];
            }
            {
                job_name = "prometheus";
                static_configs = [ { targets = [
                  "127.0.0.1:9090"
                ] ; } ];
            }
            {
                job_name = "collectd";
                static_configs = [ { targets = [
                    "127.0.0.1:9103" 
                ] ; } ];
            }
        ];
    };

    services.grafana = {
        enable = true;

        port = 3002;

        analytics.reporting.enable = false;
        rootUrl = "https://grafana.kloenk.de/";
        security.secretKey = secrets.signingKey;
        security.adminUser = "kloenk";
        security.adminPassword = secrets.adminPassword;

        database = {
            type = "postgres";
            host = "127.0.0.1:5432";
            user = "grafana";
            password = "foobar";
        };

        smtp = {
            enable = true;
            fromAddress = "grafana@kloenk.de";
            user = "grafana@kloenk.de";
            passwordFile = toString <secrets/grafana.mail>;
        };
    };

    systemd.services.grafana.after = [ "postgresql.service" ];

    services.nginx.virtualHosts."grafana.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:3002";
    };

    services.nginx.virtualHosts."localhost" = {
        enableACME = false;
        forceSSL = false;
        listen = [ { addr = "127.0.0.1"; port = 9113; } ];
        locations."/nginx_status".extraConfig = ''
          stub_status on;
          allow 127.0.0.1;
          deny all;
        '';
    };

    services.collectd2.plugins.nginx.options.URL = "http://localhost:9113/nginx_status";
}
