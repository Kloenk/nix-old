{ pkgs, ... }:


{
    imports = [
        ./common/named-common.nix
    ];

    networking.firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    services.bind = {
        extraOptions = ''
response-policy { zone \"rpz\"; };
also-notify { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
allow-transfer { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
'';

        extraConfig = ''
statistics-channels {
  inet 127.0.0.1 port 8053;
};
        '';
        cacheNetworks = [ "any" ];

        zones = [
            {
            name = "kloenk.de";
            master = true;
            file = "/etc/nixos/secrets/kloenk.zone";
            slaves = [ "159.69.179.160" "51.254.249.185" "51.254.249.182" "216.218.133.2" "2001:470:600::2" "5.45.100.14" "164.132.31.112" ];
            #also-notify { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
            #allow-transfer { 159.69.179.160; 51.254.249.185; 192.168.42.4; 51.254.249.182; 192.168.42.7; 216.218.133.2; 2001:470:600::2; 5.45.100.14; 164.132.31.112; };
        }
        #{
        #    name = "calliopa.eu";
        #    file = "/var/named/db.eu.calliopa.zone";
        #    master = false;
        #    masters = [ "87.79.92.36" ];
        #}
        {
          name = "rpz";
          master = true;
          file = "/etc/nixos/secrets/rpz.zone";
        }
        ];
  };
  services.collectd2.extraConfig = ''
    <Plugin "bind">
      URL "http://localhost:8053/"
      OpCodes         true
      QTypes          true
      
      ServerStats     true
      ZoneMaintStats  true
      ResolverStats   false
      MemoryStats     true
      
      <View "_default">
        QTypes        true
        ResolverStats true
        CacheRRSets   true
        
        Zone "127.in-addr.arpa/IN"
      </View>

      <View "kloenk">
        QTypes        true
        ResolverStats true
        CacheRRSets   true
        
        Zone "kloenk.de/IN"
      </View>
    </Plugin>
  '';
}
