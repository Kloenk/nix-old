{ config, pkgs, ... }:

{
  services.collectd2.enable = true;
  services.collectd2.enableSyslog = true;

  services.collectd2.plugins = {
    ping.options.Host = "1.1.1.1";
    cpu.options.ValuesPercentage = true;
    disk.options.IgnoreSelected = true;
    write_prometheus.options.Port = "9103";
    
    memory.hasConfig = false;
    swap.hasConfig = false;
    interface.hasConfig = false;
    df.hasConfig = false;
    load.hasConfig = false;
    uptime.hasConfig = false;
    entropy.hasConfig = false;
    dns.hasConfig = false;
    users.hasConfig = false;
  };
}