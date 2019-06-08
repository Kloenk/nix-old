{ pkgs, lib, ... }:

let
  sectrets = import /etc/nixos/secrets.nix;
in {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    authentication = lib.mkForce ''
      # Generated file; do not edit!
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
      host    all             all             192.168.42.0/24         trust
    '';
  };

  services.postgresql.initialScript = pkgs.writeText "postgres-initScript" ''
    CREATE ROLE quassel WITH LOGIN PASSWORD '${secrets.postgres.quassel}' CREATEDB;
    CREATE DATABASE quassel;
    GRANT ALL PRIVILEGES ON DATABASE quassel TO quassel;
    CREATE ROLE gitea WITH LOGIN PASSWORD '${secrets.postgres.gitea}' CREATEDB;
    CREATE DATABASE gitea;
    GRANT ALL PRIVILEGES ON DATABASE gitea TO gitea;
    CREATE ROLE grafana WITH LOGIN PASSWORD '${secrets.postgres.grafana}' CREATEDB;
    CREATE DATABASE grafana;
    GRANT ALL PRIVILEGES ON DATABASE grafana TO grafana;
  '';
}