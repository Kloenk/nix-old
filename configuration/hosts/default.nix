{
  kloenkX = {
    hostname = "kloenk@kloenkX.kloenk.de:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };
  hubble = {
    hostname = "kloenk@hubble.kloenk.de:62954";
    #prometheusExporters = [ 9100 3001 9090 9154 9187 7980 9586 9119 9166 9113 ];
    prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };
  titan = {
    #hostname = "kloenk@titan.kloenk.de:62954";
    hostname = "kloenk@192.168.178.171:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };
  atom = {
    hostname = "kloenk@192.168.178.248:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };
  nixos-builder-1 = {
    hostname = "kloenk@192.168.178.48:62954";
    prometheusExporters = [ "node-exporter" "nginx-exporter" ];
  };
}
