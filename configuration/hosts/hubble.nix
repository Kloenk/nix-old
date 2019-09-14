{ config, pkgs, lib, ... }:

# backupdirs:
#  - /var/vmail
#  - /var/dkim



let
  secrets = import /etc/nixos/secrets.nix;
  netFace = "eth0";
in {
  imports = [
    ../../default.nix
    ../users.nix
    ../ssh.nix
    ../collectd.nix

    ../server/common/nginx-common.nix
    ../server/wireguard.nix
    ../server/named-hubble.nix
    ../server/docker.nix
    #../server/gitlab.nix
    ../server/gitea.nix
    ../server/mail.nix
    ../server/monitoring.nix
    ../server/postgres.nix
    ../server/quassel.nix
    ../server/deluge.nix
    #../server/minecraft.nix
    ../server/codimd.nix
    ../server/firefox.nix
    #../server/llgcompanion.nix

    # fallback for detection
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];
  swapDevices = [ { device = "/dev/vda2"; randomEncryption = { enable = true; source = "/dev/random"; }; } ]; # change

  boot.supportedFilesystems = [ "f2fs" "ext4" "ext2" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vdb"; # change
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    #"ip=51.254.249.187::164.132.202.254:255.255.255.255::eth0"
    #"ip=192.168.178.206::192.168.178.1:255.255.255.0::eth0"
  ];
  #boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.wireguard
  ];

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [
   "virtio-pci"  # network in initrd
   "aes_x86_64"
   "aesni_intel"
   "cryptd"
   "ata_piix"
   "uhci_hcd"
   "virtio_pci"
   "sr_mod"
   "virtio_blk"
  ];
  nix.maxJobs = lib.mkDefault 8;

  fileSystems."/" = {
    device = "/dev/mapper/cryptRoot";
    fsType = "f2fs";
  };

  fileSystems."/boot" = {
    device = "/dev/vdb1";
    fsType = "ext2";
  };

  fileSystems."/data" = {
    device = "/dev/mapper/cryptData";
    fsType = "ext4";
    #:encrypted = {
    #  enable = true;
    #  blkDev = "/dev/vda1"; # change
    #  label = "cryptData";
    #  keyFile = "/etc/nixos/secrets/cryptData.key";
    #};
  };

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices."cryptData".device = "/dev/vda1";
  boot.initrd.luks.devices."cryptRoot".device = "/dev/vdb2"; # change
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDdSaiG/HVCTp4QTaAd+ZG6UNyKvMjOTRp1ILdJQQQ4a7bDW48bU9V6KxR3Ra5nhegG/UJHLheGKnh80SS3e0/Ftc4N1YjmzaSBud7JVJFG7dJtGjHPiMkqoaE9qKFtGchNCOuv0gF1AlDJ0iCI3aK0hncoXo9m/FXl703a/4Ljy457ww/KD53nallkbAAL9uAn8bVCocfxCsVHj3RPHHovL3xh8/2YaP21RxRoM4CJsdOesfmj9QSFMNP4SFpDuM1f3o8/I5AvE19fyNdgWo1nRRzeRRtoRZtudKDp6FxRf40H16t1DIaNFDt0pS1NpBNJw1I1Le64cQa0UInSWjfEXYhAa0ZTtb3q/9CvMRehHoTBACC6l5bFTE6DhRnkiJr9BucXy8eVrnF6E6JokVnqMbAM7MsOv5Z2vGTprfdXnv1eSOVSAvTxOk797fwIa3PDg/Auy8Xbwd1kSoXoDlzcc7u3WBeaxQmkpOEI2nM0KvqRy9+ISGdBwdYX4VrnWALrQhfT20yu/OmgbPwOwDXzww72+OovvtaEXIP55SzpVN0keSt6u/Y9/pc7wazxEx0BEuTfjtj9+hXXx4W6zT5ykdd0h7drObklkdEea4M/wCaa8gUNL/EKk3lNnXjwr7zZ1uIHOMsZND6T8X1VTpIx8MTuqiqgktLPxQxSzpgiCw== encrypt@hubble-initrd" ];
    port = 62954;
  };
  # setup network
  boot.initrd.preLVMCommands = lib.mkBefore (''
ip li set eth0 up
ip addr add 51.254.249.187/32 dev eth0
ip route add 164.132.202.254/32 dev eth0
ip route add default via 164.132.202.254 dev eth0 && hasNetwork=1 
'');

  networking.firewall.allowedTCPPorts = [ 9092 ];


  networking.hostName = "hubble";
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  #networking.interfaces.eth0.ipv4.addresses = [ { address = "192.168.178.206"; prefixLength = 32; } ];
  #networking.defaultGateway = { address = "192.168.178.1"; interface = netFace; };
  #networking.interfaces.eth0.ipv4.addresses = [ { address = "51.254.249.187"; prefixLength = 32; } ];
  #networking.defaultGateway = { address = "164.132.202.254"; interface = netFace; };
  #networking.interfaces.eth0.ipv6.addresses = [ { address = "2001:41d0:1004:1629:1337:0187::"; prefixLength = 112; } ];
  #networking.defaultGateway6 = { address = "2001:41d0:1004:16ff:ff:ff:ff:ff"; interface = netFace; };
#  powerManagement.powerUpCommands = ''
#${pkgs.iproute}/bin/ip -6 addr add 2001:41d0:1004:1629:1337:0187::/112 dev eth0
#${pkgs.iproute}/bin/ip -6 route add 2001:41d0:1004:16ff:ff:ff:ff:ff/128 dev eth0
#${pkgs.iproute}/bin/ip -6 route add default via 2001:41d0:1004:16ff:ff:ff:ff:ff dev eth0'';
  systemd.services.network = {
    description = "setup ipv6 network address";
    preStart = ''
#${pkgs.iproute}/bin/ip -6 addr add 2001:41d0:1004:1629:1337:0187::/112 dev eth0
#${pkgs.iproute}/bin/ip -6 route add 2001:41d0:1004:16ff:ff:ff:ff:ff/128 dev eth0
#${pkgs.iproute}/bin/ip -6 route add default via 2001:41d0:1004:16ff:ff:ff:ff:ff dev eth0'';
    serviceConfig = {
      ExecStart = "ping -6 google.com -c 2";
      Type = "oneshot";
    };
  };
  networking.nameservers = [ "8.8.8.8" ];

  # make sure dirs exists
  system.activationScripts = {
    data-http = {
      text = ''mkdir -p /data/http/kloenk /data/http/schule;
      chown -R nginx:nginx /data/http/'';
      deps = [];
    };
  };

  services.nginx.virtualHosts."kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    root = "/data/http/kloenk";
    locations."/PL".extraConfig = "return 301 https://www.dropbox.com/sh/gn1thweryxofoh3/AAC3ZW_vstHieX-9JIYIBP_ra;";
    locations."/pl".extraConfig = "return 301 https://www.dropbox.com/sh/gn1thweryxofoh3/AAC3ZW_vstHieX-9JIYIBP_ra;";
  };

  services.nginx.virtualHosts."llgcompanion.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3004/";
  };


  services.nginx.virtualHosts."schule.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    root = "/data/http/schule";
    locations."/".extraConfig = "autoindex on;";
  };

  services.nginx.virtualHosts."ftb.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    root = "/data/http/ftb";
    locations."/".extraConfig = "autoindex on;";
  };

  services.nginx.virtualHosts."politics.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    root = "/data/http/schule/sw/information/";
    locations."/".extraConfig = "autoindex on;";
  };

  services.nginx.virtualHosts."fwd.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/status/lycus".extraConfig = "return 301 http://grafana.llg/d/OVH6Hfliz/lycus?refresh=10s&orgId=1;";
      "/status/pluto".extraConfig = "return 301 https://munin.kloenk.de/llg/pluto/index.html;";
      "/status/yg-adminpc".extraConfig = "return 301 http://grafana.llg/d/6cyIlJlmk/yg-adminpc?refresh=5s&orgId=1;";
      "/status/hubble".extraConfig = "return 301 https://grafana.kloenk.de;";
      "/video".extraConfig = "return 301 https://media.ccc.de/v/jh-berlin-2018-27-config_foo;";
    };
  };

  # mosh
  programs.mosh.enable = true;
  programs.mosh.withUtempter = true;
  

  services.vnstat.enable = true;

  # auto update/garbage collector
  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";

  # fix tar gz error in autoupdate
  systemd.services.nixos-upgrade.path = with pkgs; [  gnutar xz.bin gzip config.nix.package.out ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";
}
