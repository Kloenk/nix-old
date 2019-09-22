{ config, pkgs, lib, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
  imports = [
    ../../default.nix
    ../users.nix
    ../ssh.nix
    ../desktop/dwm.nix
    ../desktop/applications.nix
    ../desktop/multimon.nix
    ../collectd.nix

    # x230 configuration
    #<nixos-hardware/lenovo/thinkpad/x230> 
    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  #nix.nixPath = [ "nixpkgs=/home/kloenk/nix/nixpkgs" "nixos=/home/kloenk/nix/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];

  hardware.cpu.intel.updateMicrocode = true;

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";

  # f2fs support
  boot.supportedFilesystems = [ "f2fs" "ext2" "nfs" "cifs" ];

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [
   #"i915"         # fixes coreboot stage 1 graphics
   "aes_x86_64"
   "aesni_intel"
   "cryptd"
   "xhci_pci"
   "ehci_pci"
   "ahci"
   "usb_storage"
   "sd_mod"
   "sdhci_pci"
  ];
  boot.kernelModules = [ "kvm-intel" "acpi_call" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.acpi_call
    config.boot.kernelPackages.tp_smapi
    config.boot.kernelPackages.wireguard
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b08058b8-9449-4ca7-9c75-d3951f9f6cbc";
      fsType = "f2fs";
    };

  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices."cryptRoot".device = "/dev/disk/by-uuid/1459400b-e15a-4fc0-87a1-d03ae5cbd337";
  boot.initrd.luks.devices."cryptHome".device = "/dev/disk/by-uuid/685221e0-dbeb-4d1a-bbef-990f0193c0b8";

  fileSystems."/boot"  = {

    device = "/dev/disk/by-uuid/9f05583b-9bc4-4be3-8e1c-9bb1e7dc5240";
    fsType = "ext2";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/cryptHome";
    fsType = "f2fs";
  };

  # nfs foo
  fileSystems."/export/home" = {
    device = "/home";
    options = [ "bind" ];
  };

  fileSystems."/export/kloenk" = {
    device = "/home/kloenk";
    options = [ "bind" ];
  };

  services.logind.lidSwitchDocked = "ignore";

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export		192.168.178.65(rw,fsid=0,no_subtree_check) 192.168.178.245(rw,fsid=0,no_subtree_check) 192.168.178.171(rw,fsid=0,no_subtree_check)
    /export/home 	192.168.178.65(rw,no_subtree_check,no_root_squash) 192.168.178.171(rw,no_subtree_check,no_root_squash)
    /export/kloenk	192.168.178.65(rw,no_subtree_check,no_root_squash) 192.168.178.171(rw,no_subtree_check,no_root_squash)
  '';
  services.nfs.server.mountdPort = 4002;
  services.nfs.server.lockdPort = 4001;
  services.nfs.server.statdPort = 4000;
  
  networking.firewall.allowedUDPPorts = [
    4000 # statd
    4001 # lockd
    4002 # mountd
    111
    2049
  ];
  networking.firewall.allowedTCPPorts = [
    4000 # statd
    4001 # lockd
    4002 # mountd
    111
    2049
  ];

  swapDevices = [
    { device = "/dev/disk/by-id/ata-SAMSUNG_SSD_PM871_mSATA_128GB_S20FNXAGC19931-part3"; randomEncryption= { enable = true; source = "/dev/random"; }; }
  ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  # set battery threshold (not supported by coreboot)
  powerManagement.powerUpCommands = "${pkgs.tlp}/bin/tlp setcharge 70 90 bat0";
  # enable autotune for linux with powertop (intel)
  #powerManagement.powertop.enable = true; # auto tune software

  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "KloenkX";
  networking.wireless.enable = true;
  networking.wireless.networks = secrets.wifiNetworks;
  networking.extraHosts = ''
    172.16.0.1 airlink.local unit.local
  '';
  #systemd.services.dhcpcd.serviceConfig.ExecStart = lib.mkForce "@${pkgs.dhcpcd}/sbin/dhcpcd dhcpcd -b -q -A -z wlp3s0";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.firewall.interfaces."wg0" = {
    allowedTCPPortRanges = [ { from = 1; to = 65534; } ];
    allowedUDPPortRanges = [ { from = 1; to = 65534; } ];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.42.6/24" "2001:41d0:1004:1629:1337:187:1:6/120" ];
      privateKeyFile = "/etc/nixos/secrets/wg0.key";
      peers = [ 
        {
          publicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
          allowedIPs = [ "192.168.42.0/24" "2001:41d0:1004:1629:1337:187:1:0/120" "2001:41d0:1004:1629:1337:187:0:1/128" ];
          endpoint = "51.254.249.187:51820";
          persistentKeepalive = 21;
          presharedKeyFile = "/etc/nixos/secrets/wg0.psk";
        }
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.etc.qemu-ifup.source = pkgs.writeText "qemu-ifup" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.iproute}/bin/ip l set dev $1 up
  '';
  environment.etc.qemu-ifdown.source = pkgs.writeText "qemu-ifdown" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.iproute}/bin/ip l set dev $1 down
  '';
  environment.etc.qemu-ifup.mode = "0755";
  environment.etc.qemu-ifdown.mode = "0755";

  environment.systemPackages = with pkgs; [
    davfs2
  ];

  # make autoupdates
  #system.autoUpgrade.enable = true;

  #services.logind.lidSwitch = "ignore";
  services.tlp.enable = true;
  users.users.kloenk.packages = with pkgs; [
    lm_sensors
    tpacpi-bat
    acpi                   # fixme: not in the kernel
    wine                   # can we ditch it?
    firefox                # used because of netflix :-(
    spotifywm              # spotify fixed for wms
    python                 # includes python2 as dependency for vscode
    platformio             # pio command
    openocd                # pio upload for stlink
    stlink                 # stlink software
    #teamspeak_client       # team speak

    # steam
    #steam
    steamcontroller    

    # minecraft
    multimc

    # docker controller
    docker
    virtmanager
  ];


  # docker fo
  virtualisation.docker.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
  };

  users.users.kloenk.extraGroups = [
    "dialout"  # allowes serial connections
    "plugdev"  # allowes stlink connection
    "davfs2"   # webdav foo
    "docker"   # docker controll group
    "libvirtd" # libvirt group
  ];

  services.udev.packages = [ pkgs.openocd ];

  services.pcscd.enable = true;
  #services.pcscd.plugins = with pkgs; [ ccid pcsc-cyberjack ];


  hardware.bluetooth.enable = true;

  # add bluetooth sink
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  hardware.pulseaudio.zeroconf.discovery.enable = true;

  # write to collect server
  services.collectd2.plugins.network.options.Server = "51.254.249.187";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09";
}
