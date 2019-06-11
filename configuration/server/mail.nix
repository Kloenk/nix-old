{ ... }:

let
  secrets = import /etc/nixos/secrets.nix;

in {
  imports = [
    (builtins.fetchTarball "https://github.com/r-raymond/nixos-mailserver/archive/v2.1.3.tar.gz")
  ];

  networking.firewall.allowedTCPPorts = [ 143 587 25 993 ];

  mailserver = {
      enable = true;
      fqdn = "mail.kloenk.de";
      domains = [ "kloenk.de" "ad.kloenk.de" "drachensegler.kloenk.de" ];


      loginAccounts = {
          "kloenk@kloenk.de" = {
              hashedPassword = secrets.mail.kloenk;

              aliases = [ 
                  "admin@kloenk.de"

                  "postmaster@kloenk.de"
                  "hostmaster@kloenk.de"
                  "webmasteer@kloenk.de"
                  "abuse@kloenk.de"
                  "postmaster@ad.kloenk.de"
                  "hostmaster@ad.kloenk.de"
                  "webmasteer@ad.kloenk.de"
                  "abuse@ad.kloenk.de"
                  "postmaster@drachensegler.kloenk.de"
                  "hostmaster@drachensegler.kloenk.de"
                  "webmasteer@drachensegler.kloenk.de"
                  "abuse@drachensegler.kloenk.de"
              ];
          };

          "finn@kloenk.de" = {
              hashedPassword = secrets.mail.finn;

              aliases = [
                  "finn.behrens@kloenk.de"
                  "behrens.finn@kloenk.de"
                  "info@kloenk.de"
              ];
          };

          "chaos@kloenk.de" = {
              hashedPassword = secrets.mail.chaos;

              aliases = [
                  "35c3@kloenk.de"
                  "eventphone@kloenk.de"
                  "cryptoparty@kloenk.de"
              ];
          };

          "schule@kloenk.de" = {
              hashedPassword = secrets.mail.schule;
          };

          "yougen@kloenk.de" = {
              hashedPassword = secrets.mail.yougen;
          };

          "grafana@kloenk.de" = {
              hashedPassword = secrets.mail.grafana;
          };

          "ad@kloenk.de" = {
              hashedPassword = secrets.mail.ad;

              aliases = [
                  "llgcompanion@kloenk.de"
              ];

              catchAll = [
                "kloenk.de"
                "ad.kloenk.de"
            ];
          };

          "drachensegler@drachensegler.kloenk.de" = {
              hashedPassword = secrets.mail.drachensegler;

              aliases = [
                  "drachensegler@kloenk.de"
                  "dlrg@drachensegler.kloenk.de"
                  "tjaard@drachensegler.kloenk.de"
                  "tjaard@kloenk.de"
                  "schule@drachensegler.kloenk.de"
              ];

              catchAll = [
                  "drachensegler.kloenk.de"
              ];
          };

          "git@kloenk.de" = {
              hashedPassword = secrets.mail.git;
          };
      };

      extraVirtualAliases = {
          #"schluempfli@kloenk.de" = "holger@trudeltiere.de";
      };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    enableImap = true;
    enablePop3 = false;
    enableImapSsl = true;
    enablePop3Ssl = false;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };
}