{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.llgCompanion;

  userFileInt = pkgs.writeText "users.json" (builtins.toJSON cfg.users);
  configFileInt = pkgs.writeText "config.json" (builtins.toJSON cfg.config);
in
  {
    options = {
      services.llgCompanion = {
        enable = mkEnableOption "llgCompanion";

        package = mkOption {
          type = types.str;
          default = pkgs.llgCompanion;
          description = "llgCompanion Package";
        };

        node = mkOption {
          type = types.str;
          default = pkgs.nodejs-11_x;
          description = ''node package to use'';
        };

        user = mkOption {
          type = types.str;
          default = "llgcompanion";
          description = ''
            User under which llgCompanion runs
            If it is set to "llgcompanion", a user will be created.
          '';
        };

        group = mkOption {
          type = types.str;
          default = "llgcompanion";
          description = ''
            Group under which llgCompanion runs
            If it is set to "llgcompanion", a group will be created.
          '';
        };

        users = mkOption {
          type = types.hash;
          default = {};
          description = "set users";
          example = literalExample ''
          {
            admin = "$2b$08$oUVC8ne3OOLMoSKjsdrJ5.dQMInnfAHCBmWJBLOqvKy4KjVJijgui";
            foo = "$2b$08$dT/LZg92BhSs0OigjUq1/.2ZgIm9fi2bYKBq1u4yVximIPjJQQRFG";
          }
        '';
        };

        usersFile = mkOption {
          type = types.str;
          default = usersFileInt;
          description = ''user file to use'';
        };


        config.planinfo.baseUrl = mkOption {
          type = types.str;
          description = ''base url of planInfo'';
        };

        config.planinfo.schoolId = mkOption {
          type = types.str;
          description = ''id of the school in planInfo'';
        };

        config.planinfo.cookies = mkOption {
          type = types.str;
          description = ''cookie for authentification at planInfo'';
        };
        
        #config.dsb.userId = mkOption {
        #  type = types.str;
        #  default = "";
        #  description = ''dsb user id for dsb'';
        #};

        config.dsb.cookie = mkOption {
          type = types.str;
          description = ''ASP.NET and DSBmobile cookie for authentication'';
        };

        config.listenPort = mkOption {
          type = types.int;
          default = 8080;
          description = "The port to bind the (internal) llg companion to";
        };

        configFile = mkOption {
          type = types.str;
          default = configFileInt;
          description = ''configuration file for llg companion'';
        };

        subsFile = mkOption {
          type = types.str;
          default = "/tmp/llgCompanion/subs.json";
          description = ''file to use for dsb cache'';
        };

        configureNginx = mkEnableOption "Configure nginx as reverse proxy for llgCompanion";

        appDomain = mkOption {
          description = "Domain used to serve companion on";
          type = types.str;
          example = "img.example.org";
        };
      };
    };

    config = mkIf cfg.enable {

      systemd.services.llgcompanion-init = {
        script = ''
          mkdir -p $(dirname ${cfg.subsFile})
          chown ${cfg.user}:${cfg.group} $(dirname ${cfg.subsFile})
        '';
        serviceConfig = {
          Type = "oneshot";
        };
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
      };

      systemd.services.llgcompanion = {
        serviceConfig = {
          ExecStart = "${cfg.node}/bin/node ${cfg.package}/server.js --config ${cfg.configFile} --users ${cfg.usersFile} --subs ${cfg.subsFile}";
          Restart = "always";
          RestartSec = "20s";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "${cfg.package}";
        };
        after = [ "llgcompanion-init.service" "network.target" ];
        wantedBy = [ "multi-user.target" ];
      };

      services.nginx = lib.mkIf cfg.configureNginx {
        enable = true;
        virtualHosts."${cfg.appDomain}" = {
          locations."/".proxyPass = "http://127.0.0.1:${toString(cfg.config.listenPort)}/";
        };
      };

      users.users.llgcompanion = mkIf (cfg.user == "llgcompanion") {
        isSystemUser = true;
        inherit (cfg) group;
      };

      users.groups.llgcompanion = mkIf (cfg.group == "llgcompanion") { };

    };
  }