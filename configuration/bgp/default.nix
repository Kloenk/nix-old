{ config, lib, ... }:

let
  hosts = import ../hosts;
  thisHost = hosts.${config.networking.hostName};
  # for now all bgp hosts are external from AS207921
  bgpHosts = lib.filterAttrs (name: host: host ? bgp && host ? wireguard && name != config.networking.hostName) hosts;
  as = "65049";

in {
  networking.firewall.allowedUDPPorts = lib.mapAttrsToList (name: host: 51820 + host.magicNumber + thisHost.magicNumber) bgpHosts;
  networking.wireguard.interfaces = (lib.mapAttrs' (name: host: 
    let
      port = 51820 + host.magicNumber + thisHost.magicNumber;
    in lib.nameValuePair "wg-${name}" {
      privateKeyFile = toString <secrets/wg-pbb.key>;
      listenPort = port;
      ips = [ "10.23.42.${toString thisHost.magicNumber}/32" "fda0::${toString thisHost.magicNumber}/128" "fe80::${toString thisHost.magicNumber}/64" ];
      allowedIPsAsRoutes = false;
      postSetup = "wg set wg-${name} fwmark 0x51820";
      peers = [
        (
          {
            allowedIPs = [ "::/0" "0.0.0.0/0" ];
            publicKey = host.wireguard.publicKey;
          }
            //
          (
            if host.wireguard ? endpoint then
              { endpoint = lib.optionalAttrs (host.wireguard ? endpoint) "${host.wireguard.endpoint}:${toString port}"; }
            else
              {}
          )
        )
      ];
    }
  ) bgpHosts);
}
