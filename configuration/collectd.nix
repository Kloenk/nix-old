{ config, pkgs, ... }:

{
  services.collectd.enable = true;

  services.collectd.extraConfig = ''
    LoadPlugin "cpu"
    <Plugin "cpu">
      ValuesPercentage true
    </Plugin>

    LoadPlugin "memory"
    LoadPlugin "swap"
    LoadPlugin "interface"
    LoadPlugin "df"
    LoadPlugin "load"
    LoadPlugin "uptime"
    LoadPlugin "entropy"
    LoadPlugin "dns"
    LoadPlugin "users"

    <Plugin "disk">
      IgnoreSelected true
    </Plugin>

    LoadPlugin "network"
    <Plugin "network">
      Server "192.168.42.1" "25826"
    </Plugin>

    LoadPlugin "ping"
    <Plugin "ping">
      Host "1.1.1.1"
      Host "8.8.8.8"
    </Plugin>
  '';
}