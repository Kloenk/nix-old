{ config, pkgs, lib, ... }:

# backupdirs:
#  - /var/vmail
#  - /var/dkim

let
  #secrets = import /etc/nixos/secrets.nix;
  netFace = "eth0";
in {
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix # TODO

    #./sshguard.nix
    ./dns.nix
    ./gitea.nix
    ./mail.nix
    ./monitoring.nix
    ./postgres.nix
    ./quassel.nix
    ./deluge.nix

    ../../default.nix
    ../../common
    ../../common/collectd.nix

    ../../nginx-common.nix

    # fallback for detection
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  ];

  environment.variables.NIX_PATH = lib.mkForce "/var/src";
  
  boot.tmpOnTmpfs = true;

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

  services.nginx.virtualHosts."buenentechnik.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3005/";
  };

  services.nginx.virtualHosts."buehnentechnik.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3305/";
  };

  services.nginx.virtualHosts."punkte.kloenk.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3006/";
  };
  
  services.nginx.virtualHosts."punkte.landratlucas.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3306/";
  };

  # mosh
  programs.mosh.enable = true;
  programs.mosh.withUtempter = true;
  

  services.vnstat.enable = true;

  # enable docker
  networking.firewall.interfaces."docker0" = {
    allowedTCPPortRanges = [ { from = 1; to = 65534; } ];
    allowedUDPPortRanges = [ { from = 1; to = 65534; } ];
  };

  virtualisation.docker.enable = true;
  users.users.kloenk.extraGroups = [ "docker" ];
  users.users.kloenk.packages = [ pkgs.docker ];

  # auto update/garbage collector
  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";

  # fix tar gz error in autoupdate
  systemd.services.nixos-upgrade.path = with pkgs; [  gnutar xz.bin gzip config.nix.package.out ];

  security.sudo.extraConfig = ''
     collectd ALL=(root) NOPASSWD: ${pkgs.wireguard-tools}/bin/wg show all transfer
   '';

   services.collectd2.extraConfig = ''
     LoadPlugin exec

     <Plugin exec>
       Exec collectd "${pkgs.collectd-wireguard}/bin/collectd-wireguard"
     </Plugin>
   '';

  # collectd write to prometheus
  services.collectd2.plugins.write_prometheus.options.Port = "9103";
  services.collectd2.plugins.network.options = {
    Listen = "0.0.0.0";
  };
  networking.firewall.allowedUDPPorts = [ 25826 ];


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";
}
