{ config, pkgs, lib, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
  netFace = "ens18";
in {
  imports = [
    ../../default.nix
    ../users.nix
    ../ssh.nix
    ../collectd.nix

    ../server/common/nginx-common.nix
    ../server/wireguard.nix
    ../server/named-hubble.nix
    ../server/gitea.nix
    ../server/mail.nix
    ../server/monitoring.nix
    ../server/postgres.nix
    ../server/quassel.nix
    ../server/transmission.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];
  swapDevices = [ { device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L-part2"; } ];

  boot.supportedFilesystems = [ "f2fs" "ext4" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-HTS721010G9SA00_MPDZN7Y0J7WN6L";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "ip=51.254.249.187::164.132.202.254:255.255.255.255:hubble::none:8.8.8.8:8.8.4.4:" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.wireguard
  ];

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [
   "virtio-pci"  # network in initrd
   "aes_x86_64"
   "aesni_intel"
   "cryptd"
   # fill up with hardware
  ];
  nix.maxJobs = lib.mkDefault 4;

  fileSystems."/" = {
    device = "/dev/mapper/cryptRoot";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptRoot".device = "/dev/disk/";
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIU9qlUhg5rwtkSvZSXAEswUhygoCibogQyF3H66b6YZXDb1t/nA4LZq4uVdiw20FaeK1+xjf0NV4ZQRX3Mgo33VLp2rNnGN7ziEZQPSlVO2Os1u4/ycxcL1n57HoXbFwTZj+mS2BrSnAEg+3aihtUO2UX1fZFaMwI976gltX38BJDk8dINEE5VT/WEDrExM4KyofeHKvMROvlWsRuUibWFL625mqXDqVCObaG8UTvqqHjPllMW1PgR5M+qv/TvBg6Kl5EFgYJxdijN35fORsieI1AoszL9/9gymvme+83AetFl7UKgYGue+msmGQv08UEOUUrxsET/sYMvlIBcUgT76AR6bOaK93x+K+ysJcT/ejYuuS2wi9kJowakW+kSUxOgbZIAqo+9jSoezSyN4Ff6WdwBwuba6UYtS4XGT2HUIAj3ggA9yUgvzdvRrw2TrLD+Cwb5oCU3XuOjvk/lrE/yeHXlsUba6dN9CiJzpwjMXIdUGjoayfTa07/FAC+ZKVZASaPawwg5aHRp0o2R0mOceDbmyK69GvNVuh9ZeRCGNF1Kv1d/elhy8H6mTexLR8wAP71OtMVqYt7eps05vhhgpr2IoVrcDQetJsPBog9mKq2Pe5ja6oVJFr7/BOOBU4M+4NFs8jtruTZP4kEeXAk3J0QQWSyrUcGa3LHb0nTkw== encrypt@hubble" ];
    port = 62954;
  };


  networking.hostName = "hubble";
  networking.dhcpcd.enable = false;
  networking.interfaces.ens18.ipv4.addresses = [ { address = "51.254.249.187"; prefixLength = 32; } ];
  networking.defaultGateway = { address = "164.132.202.254"; interface = netFace; };
  networking.interfaces.ens0.ipv6.addresses = [ { address = "2001:41d0:1004:1629:1337:0187::"; prefixLength = 112; } ];
  networking.defaultGateway6 = { address = "fe80::1"; interface = netFace; };
  networking.nameservers = [ "8.8.8.8" ];

  services.nginx.virtualHosts."schule.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    root = "/srv/http/schule";
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
  

  services.vnstat.enable = true;

  # auto update/garbage collector
  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";
}