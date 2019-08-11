{ config, pkgs, ... }:

let
    secrets = import /etc/nixos/secrets.nix;
in {
    services.gitlab = {
        enable = true;
        backupPath = "/data/gitlab/backup";
        host = "git.kloenk.de";
        https = true;
        initialRootEmail = "git-root@kloenk.de";
        initialRootPassword = secrets.gitlab.rootpw;
        port = 443;
        statePath = "/data/gitlab/state";

        smtp = {
            enable = true;
            authentication = "plain";
            domain = "mail.kloenk.de";
            username = "gitlab@kloenk.de";
            password = secrets.gitlab.mailpw;
        };
    };
}