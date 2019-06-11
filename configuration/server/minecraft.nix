{ pkgs, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
    # make sure dirs exists
    system.activationScripts = {
      minecraft = {
        text = ''mkdir -p /data/minecraft;
        chown -R minecraft:nogroup /data/minecraft'';
        deps = [];
      };
    };

    nixpkgs.config.allowUnfree = true;
    services.minecraft-server = {
        enable = true;
        declarative = true;
        dataDir = "/data/minecraft";
        eula = true;
        openFirewall = true;
        package = pkgs.minecraft-server;
        serverProperties = {
            spawn-protection = 0;
            max-tick-time = 60000;
            "query.port" = 25565;
            allow-nether = true;
            gamemode = "survival";
            broadcast-console-to-ops = true;
            pvp = true;
            hardcore = false;
            difficulty = "easy";
            spawn-monsters = true;
            server-port = 25565;
            max-players = 10;
            leve-name = "world";
            white-list = true;
            enable-rcon = true;
            "rcon.password" = secrets.minecraft.rconPassword;
            online-mode = true;
            generate-structures = true;
            motd = "Kloenks Minecraft \rask for acces at https://github.com/Kloenk/nix/issues/new";
        };
        # https://mcuuid.net/
        whitelist = {
            Kloenk = "c16d92b1-eca1-4387-93de-4f27de56ff03";
        };
    };
}