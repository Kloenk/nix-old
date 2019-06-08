{ pkgs, ... }:


let 
    rpz-zone = pkgs.writeText "rpz.zone" ''
$ORIGIN rpz.
$TTL 1H
@       IN       SOA       atom.kloenk.de. atom.fritz.box. (
                           7
                           1H
                           15m
                           30d
                           2h )
                           NS LOCALHOST.

www.yahoo.com       CNAME    .
weather.yahoo.com   CNAME    *.
stocks.yahoo.com    CNAME    www.google.com.
ad.yahoo.com        A    127.0.0.1
    '';
in {
    imports = [
        ./common/named-common.nix
    ];

    services.bind = {
        extraOptions = "response-policy { zone 'rpz'; };";

        zones = [{
            name = "rpz";
            master = true;
            file = "${rpz-zone}";
        }];
    };

}