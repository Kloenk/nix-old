{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [
      #9090  # prometheus grap endpoint
      #9093  # prometheus alert manager
    ];

  services.prometheus = {
      enable = true;
      extraFlags = [
        "-storage.local.retention 8760h"
        "-storage.local.series-file-shrink-ratio 0.3"
        "-storage.local.memory-chunks 2097152"
        "-storage.local.max-chunks-to-persist 1048576"
        "-storage.local.index-cache-size.fingerprint-to-metric 2097152"
        "-storage.local.index-cache-size.fingerprint-to-timerange 1048576"
        "-storage.local.index-cache-size.label-name-to-label-values 2097152"
        "-storage.local.index-cache-size.label-pair-to-fingerprints 41943040"
    ];
    alertmanagerURL = [ "http://localhost:9093" ];
    scrapeConfigs = [
        {
          job_name = "node";
          scrape_interval = "10s";
          static_configs = [
            {
              targets = [
                "localhost:9100"
              ];
              labels = {
                alias = "kloenk.de";
              };
            }
            {
              targets = [
                "localhost:9999"
              ];
              labels = {
                alias = "opentracker";
              };
            }
          ];
        }
    ];
  };
}