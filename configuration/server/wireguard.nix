{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.wireguard pkgs.wireguard-tools ];

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" "wgFam" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 51821 ];

    extraCommands = ''
    iptables -t nat -A POSTROUTING -s 192.168.42.0/24 -o ens18 -j MASQUERADE
    '';
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.42.1/24" "2001:41d0:1004:1629:1337:187:0:1/128" "2001:41d0:1004:1629:1337:187:1:0/120" ];

      listenPort = 51820;

      privateKeyFile = "/etc/nixos/secrets/wg0.key";

      peers = [
          { # kloenkX
            publicKey = "cTpyxiMfKTdytWMV+lMAUazQPPLAax7rZ98kvPT96no=";

            allowedIPs = [ "192.168.42.6/32" "2001:41d0:1004:1629:1337:187:1:6/128" ];

            presharedKeyFile = "/etc/nixos/secrets/wg0.kloenkX.psk";

            persistentKeepalive = 21;
          }
          { # atom
            publicKey = "AeMU4WkxJh/r1LR4jl3ROKIsuSLzYYUw4hOwbK/k8gY=";

            allowedIPs = [ "192.168.42.7/32" "2001:41d0:1004:1629:1337:187:1:7/128" ]; # TODO: add local net

            presharedKeyFile = "/etc/nixos/secrets/wg0.atom.psk";

            persistentKeepalive = 21;
          }
          { # mobile
            publicKey = "AeMU4WkxJh/r1LR4jl3ROKIsuSLzYYUw4hOwbK/k8gY=";

            allowedIPs = [ "192.168.42.9/32" "2001:41d0:1004:1629:1337:187:1:9/128" ];

            persistentKeepalive = 21;
          }
      ];
    };
    wgFam = {
      ips = [ "192.168.30.1/24" "2001:41d0:1004:1629:1337:187:30:0/120" ];

      listenPort = 51821;

      privateKeyFile = "/etc/nixos/secrets/wgFam.key";

      peers = [
        { # Namu raspi
          publicKey = "VUb1id67AUBzA8W4zulMGQMAS8sd1Lk7UbIfZAJWoV4=";

          allowedIPs = [ "192.168.30.222/32" "2001:41d0:1004:1629:1337:187:30:222/128"];

          presharedKeyFile = "/etc/nixos/secrets/wgFam.namu.psk";

          persistentKeepalive = 21;
        }
        { # IPhone mum
          publicKey = "2Yz6+oEqP01haMf9yuh99/Ojt+81CJtLFyr+BPtK+X4=";

          allowedIPs = [ "192.168.30.212/32" "2001:41d0:1004:1629:1337:187:30:212/128"];

          presharedKeyFile = "/etc/nixos/secrets/wgFam.imum.psk";

          persistentKeepalive = 21;
        }
      ];
    };
  };
}
