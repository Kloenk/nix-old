{ config, pkgs, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
  imports = [
    ../../default.nix
    ../users.nix
    ../ssh.nix
    ../server/nginx-common.nix
    ../collectd.nix

    ./atom.nfs.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  hardware.cpu.intel.updateMicrocode = true;

  fileSystems."/" = { device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L-part1";
      fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L-part2"; } ];

  boot.supportedFilesystems = [ "f2fs" "ext4" "nfs" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.wireguard
  ];

  networking.hostName = "atom";
  networking.dhcpcd.enable = false;
  networking.interfaces.eno0.ipv4.addresses = [ { address = "192.168.178.249"; prefixLength = 24; } ];
  networking.defaultGateway = "192.168.178.1";
  #networking.interfaces.ens0.ipv6.addresses = [ { address = "2a01:4f8:160:4107::2"; prefixLength = 64; } ];
  #networking.defaultGateway6 = { address = "fe80::1"; interface = "enp4s0"; };
  networking.nameservers = [ "192.168.178.1" "8.8.8.8" ];
  networking.wireless.enable = true;

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.42.7/24" ];
      privateKeyFile = "/etc/nixos/secrets/wg0.key";
      peers = [ 
        {
          publicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
          allowedIPs = [ "192.168.42.0/24" ];
          endpoint = "51.254.249.187:4242";
          persistentKeepalive = 21;
          presharedKeyFile = "/etc/nixos/secrets/wg0.psk";
        }
      ];
    };
  };

  services.vnstat.enable = true;
  system.autoUpgrade.enable = true;

  system.stateVersion = "19.03";
}