{ config, pkgs, ... }:

let
    secrets = import /etc/nixos/secrets.nix;
in {

    services.nginx.virtualHosts."git.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:3000";
    };

    #services.gitlab = {
    #    enable = true;
    #    backupPath = "/data/gitlab/backup";
    #    host = "git.kloenk.de";
    #    https = true;
    #    initialRootEmail = "git-root@kloenk.de";
    #    initialRootPassword = secrets.gitlab.rootpw;
    #    port = 443;
    #    statePath = "/data/gitlab/state";

    #    smtp = {
    #        enable = true;
    #        authentication = "plain";
    #        domain = "mail.kloenk.de";
    #        username = "gitlab@kloenk.de";
    #        password = secrets.gitlab.mailpw;
    #    };
    #};
}