{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.wireguard pkgs.wireguard-tools ];

  networking.firewall = {
    allowedUDPPorts = [
      51820 # wg0
      51821 # wgFam
      51822 # llg0
    ];
  };

  systemd.network.netdevs."30-wg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg0";
    };
    wireguardConfig = {
      FwMark = 51820;
      ListenPort = 51820;
      PrivateKeyFile = config.krops.secrets.files."wg0.key".path;
    };
    wireguardPeers = [
      { # kloenkX
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.42.6/32" "2001:41d0:1004:1629:1337:187:1:6/128" "2a0f:4ac0:f199:42::6/128" ];
          PublicKey = "cTpyxiMfKTdytWMV+lMAUazQPPLAax7rZ98kvPT96no=";
          PresharedKeyFile = config.krops.secrets.files."wg0.kloenkX.psk".path;
          PersistentKeepalive = 21;
        };
      } { # titan
        wireguardPeerConfig = {
          AllowedIPs = [ "192.168.42.3/32" "2001:41d0:1004:1629:1337:187:1:3/128" "2a0f:4ac0:f199:42::3/128" ];
          PublicKey = "4SUbImacuAjRwiK/G3CTmczirJQCI20EdJvPwJfCQxQ=";
          PresharedKeyFile = config.krops.secrets.files."wg0.titan.psk".path;
          PersistentKeepalive = 21;
        };
      } { # atom
        wireguardPeerConfig = { 
          AllowedIPs = [ "192.168.42.7/32" "2001:41d0:1004:1629:1337:187:1:7/128" "2a0f:4ac0:f199:42::7/128" ];
          PublicKey = "009Wk3RP7zOmu61Zc7ZCeS6lJyhUcXZwZsBJoadHOA0=";
          PresharedKeyFile = config.krops.secrets.files."wg0.atom.psk".path;
          PersistentKeepalive = 21;
        };
      }
    ];
  };
  systemd.network.networks."30-wg0" = {
    name = "wg0";
    addresses = [
      {
        addressConfig.Address = "192.168.42.1/24";
      }
      {
        addressConfig.Address = "2001:41d0:1004:1629:1337:187:1:0/120";
      }
      {
        addressConfig.Address = "2001:41d0:1004:1629:1337:187:1:1/120";
      }
      {
        addressConfig.Address = "2001:41d0:1004:1629:1337:187:0:1/128";
      }
      {
        addressConfig.Address = "2a0f:4ac0:f199:42::1/64";
      }
    ];
    routes = [
      {
        routeConfig.Destination = "192.168.42.0/24";
        routeConfig.Table = "51820";
      }
      {
        routeConfig.Destination = "2001:41d0:1004:1629:1337:187:1:0/120";
        routeConfig.Table = "51820";
      }
      {
        routeConfig.Destination = "2a0f:4ac0:f199:42::/64";
        routeConfig.Table = "51820";
      }
    ];
  };

  systemd.network.netdevs."30-wgFam" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wgFam";
    };
    wireguardConfig = {
      FwMark = 51820;
      ListenPort = 51821;
      PrivateKeyFile = config.krops.secrets.files."wgFam.key".path;
    };
    wireguardPeers = [
      { # Namu Raspi
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.30.222/32" "2a0f:4ac0:f199:fa14::222/128" ];
           PublicKey = "VUb1id67AUBzA8W4zulMGQMAS8sd1Lk7UbIfZAJWoV4=";
           PresharedKeyFile = config.krops.secrets.files."wgFam.namu.psk".path;
           PersistentKeepalive = 21;
        };
      }  
      { # nein Drachensegler
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.30.3/32" "2a0f:4ac0:f199:fa14::3/128" ];
           PublicKey = "esYAvRGkZ1cRsPoqBVHWjKsKysB7SVv5pNz783k4cXs=";
           #PresharedKeyFile = config.krops.secrets.files."wgFam.namu.psk".path;
           PersistentKeepalive = 21;
        };
      }  
      { # IPhone mum
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.30.212/32" "2a0f:4ac0:f199:fa14::212/128" ];
           PublicKey = "2Yz6+oEqP01haMf9yuh99/Ojt+81CJtLFyr+BPtK+X4=";
           PresharedKeyFile = config.krops.secrets.files."wgFam.imum.psk".path;
           PersistentKeepalive = 21;
        };
      }
    ];
  };
  systemd.network.networks."30-wgFam" = {
    name = "wgFam";
    addresses = [
      { addressConfig.Address = "192.168.30.1/24"; }
      { addressConfig.Address = "2a0f:4ac0:f199:fa14::/64"; }
    ];
    routes = [
      { routeConfig.Destination = "192.168.30.0/24"; routeConfig.Table = "51820"; }
      { routeConfig.Destination = "2a0f:4ac0:f199:fa14::/64"; }
    ];
  };


  systemd.network.netdevs."30-llg0" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "llg0";
    };
    wireguardConfig = {
      FwMark = 51820;
      ListenPort = 51822;
      PrivateKeyFile = config.krops.secrets.files."llg0.key".path;
    };
    wireguardPeers = [
      { # io
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.43.2/32" "2a0f:4ac0:f199:119::2/128" ];
           PublicKey = "rzyPnz6iliO5hyggfUJcmDrNeFPtMDeWRsq3liEfdQ4=";
           PresharedKeyFile = config.krops.secrets.files."llg0.io.psk".path;
           PersistentKeepalive = 21;
        };
      }  
      { # kloenkX
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.43.10/32" "2a0f:4ac0:f199:199::10/128" ];
           PublicKey = "MYNYNLmxTBsr30JsHV1qSqKqA3Gk54wLaKJn/uwBBiY=";
           #PresharedKeyFile = config.krops.secrets.files."llg0.kloenkX.psk".path;
           PersistentKeepalive = 21;
        };
      }  
      { # phoenix 
        wireguardPeerConfig = {
           AllowedIPs = [ "192.168.43.235/32" "2a0f:4ac0:f199:199::235/128" ];
           PublicKey = "IVwWeSQ034oDQytB3IfaxWI5yQcfzz977dN7Ak8nSD8=";
           #PresharedKeyFile = config.krops.secrets.files."wgFam.imum.psk".path;
           PersistentKeepalive = 21;
        };
      }
    ];
  };
  systemd.network.networks."30-llg0" = {
    name = "llg0";
    addresses = [
      { addressConfig.Address = "192.168.43.1/24"; }
      { addressConfig.Address = "2a0f:4ac0:f199:199::/64"; }
    ];
    routes = [
      { routeConfig.Destination = "192.168.43.0/24"; routeConfig.Table = "51820"; }
      { routeConfig.Destination = "2a0f:4ac0:f199:199::/64"; }
    ];
  };

  

  systemd.network.networks."70-wg-priv" = {
    name = "*";
    extraConfig = ''
      [RoutingPolicyRule]
      Table = 51820
      Family = both
      Priority = 25000
    '';
  };
     

  krops.secrets.files."wg0.key".owner = "systemd-network";
  krops.secrets.files."wg0.titan.psk".owner = "systemd-network";
  krops.secrets.files."wg0.kloenkX.psk".owner = "systemd-network";
  krops.secrets.files."wg0.atom.psk".owner = "systemd-network";
  krops.secrets.files."wgFam.key".owner = "systemd-network";
  krops.secrets.files."wgFam.namu.psk".owner = "systemd-network";
  krops.secrets.files."wgFam.imum.psk".owner = "systemd-network";
  krops.secrets.files."llg0.key".owner = "systemd-network";
  krops.secrets.files."llg0.io.psk".owner = "systemd-network";
  krops.secrets.files."llg0.kloenkX.psk".owner = "systemd-network";
  
  users.users.systemd-network.extraGroups = [ "keys" ];

  #networking.interfaces.wg0 = {
  #  ipv4.addresses = [
  #    { address = "192.168.42.1"; prefixLength = 24; }
  #  ];
  #  ipv4.routes = [
  #    { address = "192.168.42.0"; prefixLength = 24; }
  #  ];
  #  ipv6.addresses = [
  #    { address = "2001:41d0:1004:1629:1337:187:0:1"; prefixLength = 128; }
  #    { address = "2001:41d0:1004:1629:1337:187:1:0"; prefixLength = 120; }
  #  ];
  #  ipv6.routes = [
  #    { address = "2001:41d0:1004:1629:1337:187:1:0"; prefixLength = 120; }
  #  ];
  #};
  #networking.interfaces.wgFam = {
  #  ipv4.addresses = [
  #    { address = "192.168.30.1"; prefixLength = 24; }
  #  ];
  #  ipv4.routes = [
  #    { address = "192.168.30.0"; prefixLength = 24; }
  #  ];
  #  ipv6.addresses = [
  #    { address = "2001:41d0:1004:1629:1337:187:30:0"; prefixLength = 120; }
  #  ];
  #  ipv6.routes = [
  #    { address = "2001:41d0:1004:1629:1337:187:30:0"; prefixLength = 120; }
  #  ];
  #};
  #networking.interfaces.llg0 = {
  #  ipv4.addresses = [
  #    { address = "192.168.43.1"; prefixLength = 24; }
  #  ];
  #  ipv4.routes = [
  #    { address = "192.168.43.0"; prefixLength = 24; }
  #    { address = "10.0.0.0"; prefixLength = 8; options.metric = "3192"; }
  #  ];
  #  ipv6.addresses = [
  #    { address = "2001:41d0:1004:1629:1337:187:43:0"; prefixLength = 120; }
  #  ];
  #  ipv6.routes = [
  #    { address = "2001:41d0:1004:1629:1337:187:43:0"; prefixLength = 120; }
  #  ];
  #};

  #networking.wireguard.interfaces = {
  #  wg0 = {
  #    ips = [ ];

  #    listenPort = 51820;

  #    privateKeyFile = toString <secrets/wg0.key>;
  #    #allowedIPsAsRoutes = false;

  #    peers = [
  #      { # kloenkX
  #        publicKey = "cTpyxiMfKTdytWMV+lMAUazQPPLAax7rZ98kvPT96no=";

  #        allowedIPs = [ "192.168.42.6/32" "2001:41d0:1004:1629:1337:187:1:6/128" ];

  #        presharedKeyFile = toString <secrets/wg0.kloenkX.psk>;

  #        persistentKeepalive = 21;
  #      }
  #            { # titan
  #      	      publicKey = "4SUbImacuAjRwiK/G3CTmczirJQCI20EdJvPwJfCQxQ=";

  #      	      allowedIPs = [ "192.168.42.3/32" "2001:41d0:1004:1629:1337:187:1:3/128" ];

  #      	      presharedKeyFile = toString <secrets/wg0.titan.psk>;

  #        persistentKeepalive = 21;
  #            }
  #      { # atom
  #        publicKey = "009Wk3RP7zOmu61Zc7ZCeS6lJyhUcXZwZsBJoadHOA0=";

  #        allowedIPs = [ "192.168.42.7/32" "2001:41d0:1004:1629:1337:187:1:7/128" "192.168.178.0/24" ]; # TODO: add local net

  #        presharedKeyFile = toString <secrets/wg0.atom.psk>;

  #        persistentKeepalive = 21;
  #      }
  #      { # mobile
  #        publicKey = "AeMU4WkxJh/r1LR4jl3ROKIsuSLzYYUw4hOwbK/k8gY=";

  #        allowedIPs = [ "192.168.42.9/32" "2001:41d0:1004:1629:1337:187:1:9/128" ];

  #        persistentKeepalive = 21;
  #      }
  #    ];
  #  };
  #  wgFam = {
  #    ips = [ "192.168.30.1/24" "2001:41d0:1004:1629:1337:187:30:0/120" ];

  #    listenPort = 51821;

  #    privateKeyFile = toString <secrets/wgFam.key>;

  #    #allowedIPsAsRoutes = false;

  #    peers = [
  #      { # Namu raspi
  #        publicKey = "VUb1id67AUBzA8W4zulMGQMAS8sd1Lk7UbIfZAJWoV4=";

  #        allowedIPs = [ "192.168.30.222/32" "2001:41d0:1004:1629:1337:187:30:222/128"];

  #        presharedKeyFile = toString <secrets/wgFam.namu.psk>;

  #        persistentKeepalive = 21;
  #      }
  #      { # nein Drachensegler
  #        publicKey = "esYAvRGkZ1cRsPoqBVHWjKsKysB7SVv5pNz783k4cXs=";

  #        allowedIPs = [ "192.168.30.3/32" "2001:41d0:1004:1629:1337:187:30:3/128" ];

  #        persistentKeepalive = 21;
  #      }
  #      { # IPhone mum
  #        publicKey = "2Yz6+oEqP01haMf9yuh99/Ojt+81CJtLFyr+BPtK+X4=";

  #        allowedIPs = [ "192.168.30.212/32" "2001:41d0:1004:1629:1337:187:30:212/128"];

  #        presharedKeyFile = toString <secrets/wgFam.imum.psk>;

  #        persistentKeepalive = 21;
  #      }
  #    ];
  #  };
  #  llg0 = {
  #    ips = [ "192.168.43.1/24" "2001:41d0:1004:1629:1337:187:43:0/120" ];

  #    listenPort = 51822;

  #    privateKeyFile = toString <secrets/llg0.key>;

  #    allowedIPsAsRoutes = false;
  #    postSetup = ''
  #      ip route add 192.168.43.0/24 dev llg0 metric 1024
  #      ip -6 route add 2001:41d0:1004:1629:1337:187:43:0/120 dev llg0 # no metric, ipv6
  #      ip route add 10.0.0.0/8 dev llg0 metric 2048
  #    '';

  #    peers = [
  #      { # io
  #        publicKey = "rzyPnz6iliO5hyggfUJcmDrNeFPtMDeWRsq3liEfdQ4=";

  #        allowedIPs = [ "192.168.43.2" "2001:41d0:1004:1629:1337:187:43:2/128" "10.0.0.0/8" ];

  #        presharedKeyFile = toString <secrets/llg0.io.psk>;

  #        persistentKeepalive = 21;
  #      }
  #      { # kloenkX
  #        publicKey = "MYNYNLmxTBsr30JsHV1qSqKqA3Gk54wLaKJn/uwBBiY=";
  #        allowedIPs = [ "192.168.43.10" "2001:41d0:1004:1629:1337:187:43:10/128" ];
  #        presharedKeyFile = toString <secrets/llg0.kloenkX.psk>;
  #        persistentKeepalive = 21;
  #      }
  #      { # mobile
  #        publicKey = "XF/HSMyhMEPLFHLoEdZ6WhXaj2dL3EMBrNPTjx3PwGU=";
  #        allowedIPs = [ "192.168.43.11/32" "2001:41d0:1004:1629:1337:187:43:11/128" ];
  #        presharedKeyFile = toString <secrets/llg0.mobile.psk>;
  #        persistentKeepalive = 21;
  #      }
  #      { # ecue
  #        publicKey = "3/NO8zVeTISHcgtE4CoQojkpvAOJE52FlAatOOAL6CI=";
  #        allowedIPs = [ "192.168.43.241" ];
  #        persistentKeepalive = 21;
  #      }
  #            { # vepi
  #              publicKey = "a7rQr9woO8tXBf0jfPF4F39zDgskoEJJGCbkGCcgKTo=";
  #              allowedIPs = [ "192.168.43.240" "2001:41d0:1004:1629:1337:187:43:240/128" ];
  #        presharedKeyFile = toString <secrets/llg0.vepi.psk>;
  #        persistentKeepalive = 21;
  #            }
  #    ];
  #  };
  #};
}
