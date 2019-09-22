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
    ../collectd.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];


  hardware.cpu.amd.updateMicrocode = true;

  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0M344364P";
  boot.loader.grub.useOSProber = true;

  # f2fs support
  boot.supportedFilesystems = [ "f2fs" "nfs" "ntfs" ];

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [
    "ahci"
    "ohci_pci"
    "ehci_pci"
    "pata_jmicron"
    "xhci_pci"
    "firewire_ohci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.acpi_call
    config.boot.kernelPackages.wireguard
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0M344364P-part3";
      fsType = "f2fs";
    };

  #boot.initrd.luks.reusePassphrases = true;
  #boot.initrd.luks.devices."cryptRoot".device = "/dev/sda4";


  fileSystems."/boot"  = {
    device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0M344364P-part1";
    fsType = "ntfs";
  };

  fileSystems."/home/kloenk/kloenkX" = {
    device = "192.168.178.65:/kloenk";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto"];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/nixos-swap"; }
  ];

  nix.maxJobs = lib.mkDefault 4;

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # nvidia graphics drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  networking.hostName = "titan";
  networking.extraHosts = ''
    172.16.0.1 airlink.local unit.local
    192.168.178.248	atom atom.fritz.box
  '';
  networking.nameservers = [ "192.168.178.248" "1.0.0.1" ];
  networking.search = [ "fritz.box" "internal.kloenk.de" ];

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


  # make autoupdates
  #system.autoUpgrade.enable = true;

  users.users.kloenk.packages = with pkgs; [
    lm_sensors
    wine                   # can we ditch it?
    spotifywm              # spotify fixed for wms
    python                 # includes python2 as dependency for vscode
    platformio             # pio command
    openocd                # pio upload for stlink
    stlink                 # stlink software
    teamspeak_client       # team speak

    # steam
    steam
    steamcontroller    

    # minecraft
    multimc
    ftb

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
    "docker"   # docker controll group
    "libvirt"
  ];

  services.udev.packages = [ pkgs.openocd ];

  services.pcscd.enable = true;

  hardware.bluetooth.enable = true;

  # add bluetooth sink
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  hardware.pulseaudio.zeroconf.discovery.enable = true;

  services.collectd2.plugins = {
    network.options.Server = "51.254.249.187";
    sensors.hasConfig = false;
    processes.hasConfig = false;
  };


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09";
}
