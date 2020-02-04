{ ... }:

{
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
      
      allowedIPsAsRoutes = false;
      postSetup = ''
        ip route add 192.168.42.0/24 dev wg0 metric 1024
        ip route add 192.168.178.0/24 dev wg0 metric 2048
        ip -6 route add 2001:41d0:1004:1629:1337:187:1:0/120 dev wg0 # no metric, ipv6
      '';
    };
    llg0 = {
      ips = [ "192.168.43.10" "2001:41d0:1004:1629:1337:187:43:10/120" ];
      privateKeyFile = toString <secrets/llg0.key>;
      peers = [ {
        publicKey = "Ll0Zb5I3L8H4WCzowkh13REiXcxmoTgSKi01NrzKiCM=";
        allowedIPs = [ "192.168.43.0/24" "2001:41d0:1004:1629:1337:187:43:0/120" "10.0.0.0/8" ];
        endpoint = "51.254.249.187:51822";
        persistentKeepalive = 21;
        presharedKeyFile = toString <secrets/llg0.psk>;
      } ];

      allowedIPsAsRoutes = false;
      postSetup = ''
        ip route add 192.168.43.0/24 dev llg0 metric 2048
        ip -6 route add 2001:41d0:1004:1629:1337:187:43:0/120 dev llg0 # no metric, ipv6
        ip route add 10.0.0.0/8 dev llg0 metric 2048
      '';
    };
  };
}
