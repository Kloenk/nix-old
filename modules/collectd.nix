{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.collectd2;

  conf = pkgs.writeText "collectd.conf" ''
    BaseDir "${cfg.dataDir}"
    AutoLoadPlugin ${boolToString cfg.autoLoadPlugin}
    HostName "${config.networking.hostName}"

    ${optionalString cfg.enableSyslog ''
      ${optionalString (cfg.autoLoadPlugin == false) ''LoadPlugin "syslog"''}
      <Plugin "syslog">
        LogLevel "info"
        NotifyLevel "OKAY"
      </Plugin>
    ''}

    ${concatStringsSep "\n" (mapAttrsToList (name: conf:  ''
      ${optionalString (cfg.autoLoadPlugin == false) ''LoadPlugin "${name}"''}
      ${if conf.hasConfig then ''
        <Plugin "${name}">
          ${concatStringsSep "\n" (mapAttrsToList (name: value: ''
            ${name} ${if (isBool value) then boolToString value else "\"${value}\""}
          '') conf.options)}
        </Plugin>'' else if cfg.autoLoadPlugin then "LoadPlugin \"${name}\"" else ""} 
    '') cfg.plugins)}

    ${concatMapStrings (f: ''
    Include "${f}"
    '') cfg.include}

    ${cfg.extraConfig}
  '';

  pluginOpts = { name, ... }: {

    options = {
      name = mkOption {
        example = "ping";
        type = types.str;
        description = "Name of the plugin";
      };

      options = mkOption {
        default = {};
        type = with types; attrsOf (nullOr (either str (either path bool)));
        example = { Host = "1.1.1.1"; };
        description = "Config inside a plugin blog";
      };

      hasConfig = mkOption {
        default = true;
        type = with types; bool;
        example = false;
        description = "option to load config without options";
      };
    };
  };

in {
  options.services.collectd2 = with types; {
    enable = mkEnableOption "collectd agent";

    enableSyslog = mkEnableOption "enable syslog loging";

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

    plugins = mkOption {
      default = {};
      example = { ping.config.Host = "1.1.1.1"; };
      description = ''
        configuration for each plugin
      '';
      type = with types; loaOf (submodule pluginOpts);
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
      after = [ "network-online.target" ];
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