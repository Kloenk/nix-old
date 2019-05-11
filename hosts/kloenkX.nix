{ config, pkgs, lib, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
  imports = [
    ../users.nix
    ../ssh.nix
    ../desktop/i3.nix
    ../desktop/applications.nix
  ];

  #nix.nixPath = [ "nixpkgs=/home/pbb/proj/nixpkgs" "nixos=/home/pbb/proj/nixpkgs" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sdb";

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [ "aes_x86_64" "aesni_intel" "cryptd" "uhci_hcd" "ehci_pci" "hpsa" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6d399f17-5b7b-4438-b93b-15852d45ef9a";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptRoot".device = "/dev/disk/by-uuid/efcc2cf2-c4b5-493a-995b-f101703ab629";

  fileSystems."/boot"  = {
    device = "/dev/dis/by-uuid/8675-08D5";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 16;

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
  users.users.kloenk.packages = with pkgs; [ lm_sensors ];

  services.pcscd.enable = true;
  #services.pcscd.plugins = with pkgs; [ ccid pcsc-cyberjack ];

  system.stateVersion = "19.03";
}
