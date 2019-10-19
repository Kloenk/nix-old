{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.wireguard pkgs.wireguard-tools ];

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" "wgFam" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 51821 51822 ];

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
	  { # titan
		publicKey = "4SUbImacuAjRwiK/G3CTmczirJQCI20EdJvPwJfCQxQ=";

		allowedIPs = [ "192.168.42.3/32" "2001:41d0:1004:1629:1337:187:1:3/128" ];

		presharedKeyFile = "/etc/nixos/secrets/wg0.titan.psk";

                persistentKeepalive = 21;
	  }
          { # atom
            publicKey = "009Wk3RP7zOmu61Zc7ZCeS6lJyhUcXZwZsBJoadHOA0=";

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
    llg0 = {
      ips = [ "192.168.43.1/24" "2001:41d0:1004:1629:1337:187:43:0/120" ];

      listenPort = 51822;

      privateKeyFile = "/etc/nixos/secrets/llg0.key";

      peers = [
        { # io
          publicKey = "rzyPnz6iliO5hyggfUJcmDrNeFPtMDeWRsq3liEfdQ4=";

          allowedIPs = [ "192.168.43.2" "2001:41d0:1004:1629:1337:187:43:2/128" ];

          presharedKeyFile = "/etc/nixos/secrets/llg0.io.psk";

          persistentKeepalive = 21;
        }
        { # kloenkX
          publicKey = "MYNYNLmxTBsr30JsHV1qSqKqA3Gk54wLaKJn/uwBBiY=";
          allowedIPs = [ "192.168.43.10" "2001:41d0:1004:1629:1337:187:43:10/128" ];
          presharedKeyFile = "/etc/nixos/secrets/llg0.kloenkx.psk";
          persistentKeepalive = 21;
        }
        { # mobile
          publicKey = "XF/HSMyhMEPLFHLoEdZ6WhXaj2dL3EMBrNPTjx3PwGU=";
          allowedIPs = [ "192.168.43.11/32" "2001:41d0:1004:1629:1337:187:43:11/128" ];
          presharedKeyFile = "/etc/nixos/secrets/llg0.mobile.psk";
          persistentKeepalive = 21;
        }
	{ # vepi
	  publicKey = "a7rQr9woO8tXBf0jfPF4F39zDgskoEJJGCbkGCcgKTo=";
	  allowedIPs = [ "192.168.43.240" "2001:41d0:1004:1629:1337:187:43:240/128" ];
          presharedKeyFile = "/etc/nixos/secrets/llg0.vepi.psk";
          persistentKeepalive = 21;
	}
      ];
    };
  };
}
