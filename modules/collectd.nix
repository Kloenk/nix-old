{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.collectd2;

  conf = pkgs.writeText "collectd.conf" ''
    BaseDir "${cfg.dataDir}"
    AutoLoadPlugin ${boolToString cfg.autoLoadPlugin}
    HostName "${cfg.networking.hostName}"

    LoadPlugin syslog
    <Plugin "syslog">
      LogLevel "info"
      NotifyLevel "OKAY"
    </Plugin>

    ${concatMapStrings (f: ''
    Include "${f}"
    '') cfg.include}

    ${cfg.extraConfig}
  '';

in {
  options.services.collectd2 = with types; {
    enable = mkEnableOption "collectd agent";

    package = mkOption {
        default = pkgs.collectd;
        defaultText = "pkgs.collectd";
        description = ''
          Which collectd package to use
        '';
    };

    user = mkOption {
      default = "collectd";
      description = ''
        User under which to run collectd.
      '';
      type = nullOr str;
    };
  
    dataDir = mkOption {
      default = "/var/lib/collectd";
      description = ''
        Data directory for collectd agent.
      '';
      type = path;
    };
  
    autoLoadPlugin = mkOption {
      default = false;
      description = ''
        Enable plugin autoloading.
      '';
      type = bool;
    };

    include = mkOption {
      default = [];
      description = ''
        Additional paths to load config from.
      '';
      type = listOf str;
    };
    
    extraConfig = mkOption {
      default = "";
      description = ''
        Extra configuration for collectd.
      '';
      type = lines;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.collectd.enable;
        message = "you cannot enable collectd and collectd2";
      }
    ];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} - - -"
    ];

    systemd.services.collectd = {
      description = "Collectd Monitoring Agent";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
     
      serviceConfig = {
        ExecStart = "${cfg.package}/sbin/collectd -C ${conf} -f";
        User = cfg.user;
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
     
    users.users = optional (cfg.user == "collectd") {
      name = "collectd";
    };
  };
}