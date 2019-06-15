{ ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
  services.nginx.virtualHosts."llgcompanion.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
  };

  services.llgCompanion = {
    enable = true;
    users = secrets.llgcompanion.users;
    config = secrets.llgcompanion.config;
    config.listenPort = 3004;
    configureNginx = true;
    appDomain = "llgcompanion.kloenk.de";
  };
}