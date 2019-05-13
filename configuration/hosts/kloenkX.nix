{ config, pkgs, lib, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
  imports = [
    ../../default.nix
    ../users.nix
    ../ssh.nix
    ../desktop/i3.nix
    ../desktop/applications.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  #nix.nixPath = [ "nixpkgs=/home/pbb/proj/nixpkgs" "nixos=/home/pbb/proj/nixpkgs" ];

  hardware.cpu.intel.updateMicrocode = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # f2fs support
  boot.supportedFilesystems = [ "f2fs" ];

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [
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
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b5265276-b78f-45d0-a34e-2775467766f5";
      fsType = "f2fs";
    };

  boot.initrd.luks.devices."cryptRoot".device = "/dev/disk/by-uuid/5faab799-5559-452b-af82-d169f21a4d00";

  fileSystems."/boot"  = {
    device = "/dev/disk/by-uuid/E5E0-B6C0";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/1d92d5f5-ac28-44f9-9d86-389ea77500f0";}
    { device = "/dev/disk/by-uuid/a458094a-dda3-4191-be9b-432b126b241c";}
  ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

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

  #networking.wireguard.interfaces = {
  #  wg0 = {
  #    ips = [ "192.168.42.6/24" ];

  #    privateKeyFile = "/etc/nixos/secrets/wg0.key";

  #    peers = [ 
  #      {
  #        publicKey = "MUsPCkTKHBGvCI62CevFs6Wve+cXBLQIl/C3rW3PbVM=";
  #        allowedIPs = [ "192.168.42.0/24" ];
  #        endpoint = "51.254.249.187:4242";
  #        persistentKeepalive = 21;
  #        presharedKeyFile = "/etc/nixos/secrets/wg0.psk";
  #      }
  #    ];
  #  };
  #};

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

  #services.logind.lidSwitch = "ignore";
  services.tlp.enable = true;
  users.users.kloenk.packages = with pkgs; [ lm_sensors tpacpi-bat acpi ];

  services.pcscd.enable = true;
  #services.pcscd.plugins = with pkgs; [ ccid pcsc-cyberjack ];

  nixpkgs.config.allowUnfree = true; # allow unfree software

  hardware.bluetooth.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";
}
