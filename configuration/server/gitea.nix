{ ... }:

let
    secrets = import /etc/nixos/secrets.nix;

in {

    # make sure dirs exists
    system.activationScripts = {
      gitea-repositories = {
        text = ''mkdir -p /data/gitea/repositories;
        chown -R gitea:nogroup /data/gitea/repositories'';
        deps = [];
      };
    };

    networking.firewall.allowedTCPPorts = [
        22 # ssh
    ];

    services.gitea = {
        enable = true;
        stateDir = "/srv/gitea";
        log.level = "Warn";
        appName = "Kloenk's Gitea";
        domain = "git.kloenk.de";
        rootUrl = "https://git.kloenk.de";
        httpAddress = "127.0.0.1";
        httpPort = 3000;
        cookieSecure = true;
        repositoryRoot = "/data/gitea/repositories";

        database = {
            type = "postgres";
            name = "gitea";
            user = "gitea";
            passwordFile = "/etc/nixos/secrets/gitea-db.password";
            createDatabase = false;
        };

        extraConfig = ''
[repository]
PREFERRED_LICENSES = AGPL-3.0,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1

[server]
START_SSH_SERVER = true
BUILTIN_SSH_SERVER_USER = git
SSH_LISTEN_HOST = 
SSH_PORT = 22
DISABLE_ROUTER_LOG = true

[mailer]
ENABLED = true
SUBJECT = %(APP_NAME)s
HOST = localhost:587
USER = git@kloenk.de
PASSWD = "${secrets.gitea.mailpassword}"
SEND_AS_PLAIN_TEXT = true
USE_SENDMAIL = false
FROM = "Kloenks's Gitea" <gitea@kloenk.de>


[attachment]
ALLOWED_TYPES = */*

[service]
SKIP_VERIFY = true
REGISTER_EMAIL_CONFIRM = true
ENABLE_NOTIFY_MAIL = true
ENABLE_CAPTCHA = false
NO_REPLY_ADDRESS = kloenk.de
DISABLE_REGISTRATION = true
        '';
    };

    services.nginx.virtualHosts."git.kloenk.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:3000";
    };

    systemd.services.gitea.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
}