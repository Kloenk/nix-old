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
        package = pkgs.minecraft-server_1_14_2;
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
            "Kloenk" = "c16d92b1-eca1-4387-93de-4f27de56ff03";
            "LenniAConrad" = "2a1db818-6a56-48af-99f6-d1c7436bad5b";
            "ekkebaer" = "0a70a4f8-b098-4a9f-beeb-ae521fca1b23";
            "ennsworld456" = "812e9708-f096-41bc-a64d-9251c211dd32";
            "lennygb00" = "0b200212-fdb2-4c1c-b478-3bab3f9c2e27";
            "yoshi210" = "67f7fe96-3bd6-40d6-8ef2-935f6722c720";
        };
    };
}
