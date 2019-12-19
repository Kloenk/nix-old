{ ... }:

{
  networking.firewall.interfaces."wg0" = {
    allowedTCPPortRanges = [ { from = 1; to = 65534; } ];
    allowedUDPPortRanges = [ { from = 1; to = 65534; } ];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.42.6/24" "2001:41d0:1004:1629:1337:187:1:6/120" ];
      privateKeyFile = toString <secrets/wg0.key>;
      peers = [ 
        {
          publicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
          allowedIPs = [ "192.168.42.0/24" "2001:41d0:1004:1629:1337:187:1:0/120" "2001:41d0:1004:1629:1337:187:0:1/128" ];
          endpoint = "51.254.249.187:51820";
          persistentKeepalive = 21;
          presharedKeyFile = toString <secrets/wg0.psk>;
        }
      ];
    };
    llg0 = {
      ips = [ "192.168.43.10" "2001:41d0:1004:1629:1337:187:43:10/120" ];
      privateKeyFile = toString <secrets/llg0.key>;
      peers = [ {
        publicKey = "Ll0Zb5I3L8H4WCzowkh13REiXcxmoTgSKi01NrzKiCM=";
        allowedIPs = [ "192.168.43.0/24" "2001:41d0:1004:1629:1337:187:43:0/120" "10.1.0.0/16" ];
        endpoint = "51.254.249.187:51822";
        persistentKeepalive = 21;
        presharedKeyFile = toString <secrets/llg0.psk>;
      } ];
    };
  };
}