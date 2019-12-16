{ pkgs, lib, ... }:

{
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
    CREATE ROLE quassel LOGIN CREATEDB;
    CREATE DATABASE quassel;
    GRANT ALL PRIVILEGES ON DATABASE quassel TO quassel;
    CREATE ROLE gitea LOGIN CREATEDB;
    CREATE DATABASE gitea;
    GRANT ALL PRIVILEGES ON DATABASE gitea TO gitea;
    CREATE ROLE grafana LOGIN CREATEDB;
    CREATE DATABASE grafana;
    GRANT ALL PRIVILEGES ON DATABASE grafana TO grafana;
  '';
}
