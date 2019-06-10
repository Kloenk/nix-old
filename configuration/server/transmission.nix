{ ... }:

{
    # make sure dirs exists
    system.activationScripts = {
      transmission-downloads = {
        text = ''mkdir -p /data/transmission/Downloads;
        chown -R transmission:transmission /data/transmission/Downloads'';
        deps = [];
      };
    };

    services.transmission = {
        enable = true;
        settings = {
            umask = 18;
            rpc-whitelist = "192.168.42.*,127.0.0.1";
            download-dir = "/data/transmission/Downloads";
        };
    };
}