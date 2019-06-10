{ ... }:

let
  setcrets = import /etc/nixos/secrets.nix
in {
  services.nginx.virtualHosts."llgcompanion.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:3004";
  };

  
}