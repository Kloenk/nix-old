{ ... }:

{
    services.transmission = {
        enable = true;
        settings = {
            umask = 18;
            rpc-whitelist = "192.168.42.*,127.0.0.1";
        };
    };
}