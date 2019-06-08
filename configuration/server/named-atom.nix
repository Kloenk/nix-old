{ pkgs, ... }:


let 
    rpz-zone = pkgs.writeText "rpz.zone" (import ./common/named-blocklist.nix { inherit pkgs; });
    
in {
    imports = [
        ./common/named-common.nix
    ];

    services.bind = {
        extraOptions = "response-policy { zone \"rpz\"; };";

        cacheNetworks = [ "127.0.0.0/24" "192.168.178.0/24" "192.168.42.0/24" ];

        zones = [{
            name = "rpz";
            master = true;
            file = "${rpz-zone}";
        }];
    };

}