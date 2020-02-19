let 
  nixos = import ../sources/nixpkgs/nixos {
      configuration = { lib, config, ... }: {
          imports = [
              ../sources/nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
              ../sources/nixpkgs/nixos/modules/installer/cd-dvd/channel.nix
              ../configuration/common
              ../iso-extra.nix
          ];
          networking.useDHCP = false;
          boot.loader.grub.enable = false;
          boot.kernelParams = [
              "panic=30" "boot.panic_on_fail"
          ];
          boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
          systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
          networking.hostName = "kexec";


          systemd.network.networks."70-dhcp" = {
            DHCP = "yes";
            name = "*";
          };

          systemd.network.netdevs."30-wg0" = { 
            netdevConfig = { 
              Kind = "wireguard";
              Name = "wg0";
            };  
            wireguardConfig = { 
              FwMark = 51820;
              PrivateKeyFile = "/etc/systemd/network/wg.key";
            };  
            wireguardPeers = [ 
              { wireguardPeerConfig = { 
                AllowedIPs = [ "0.0.0.0/0" "::/0" ];
                PublicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
                PersistentKeepalive = 21; 
                Endpoint = "51.254.249.187:51820";
              }; }
            ];  
          };  
          systemd.network.networks."30-wg0" = { 
            name = "wg0";
            addresses = [ 
              { addressConfig.Address = "192.168.42.137/32"; }
              { addressConfig.Address = "2a0f:4ac0:f199:42::6/128"; }
            ];  
            routes = [ 
              { routeConfig.Destination = "192.168.42.0/24"; }
              { routeConfig.Destination = "2a0f:4ac0:f199:42::6/48"; }
            ];  
          };

          system.activationScripts = {
            base-dirs = {
              text = ''
                mkdir -p /nix/var/nix/profiles/per-user/kloenk
              '';
              deps = [];
            };
        };
      };
  };
in
  nixos.config.system.build.isoImage
