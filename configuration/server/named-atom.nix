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

www.yahoo.com       CNAME   .
weather.yahoo.com   CNAME   *.
stocks.yahoo.com    CNAME   .
ad.yahoo.com        CNAME   .

ads.kelbyone.com    CNAME   .
adsniper.ru         CNAME   .
adsponse.de         CNAME   .

displayads-formats.googleusercontent.com    CNAME   .
tpc.googlesyndication.com   CNAME   .
static.googleadsserving.cn  CNAME   .
googleads.g.doubleclick.net CNAME   .
blogergadgets.googlecode.com    CNAME   .
googleads4.g.doubleclick.net    CNAME   .
    '';
in {
    imports = [
        ./common/named-common.nix
    ];

    services.bind = {
        extraOptions = "response-policy { zone \"rpz\"; };";

        cacheNetworks = [ "192.168.178.0/24" "192.168.42.0/24" ];

        zones = [{
            name = "rpz";
            master = true;
            file = "${rpz-zone}";
        }];
    };

}