{ ... }:

let
  setcrets = import /etc/nixos/secrets.nix
in {
  services.nginx.virtualHosts."llgcompanion.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
  };

  services.llgcompanion = {
    enable = true;
    users = secrets.llgcompanion.users;
    config = secrets.llgcompanion.config;
    configureNginx = true;
    appDomain = "llgcompanion.kloenk.de";
  };
}