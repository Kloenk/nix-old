{ config, pkgs, lib, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
  imports = [
    ../users.nix
    ../ssh.nix
    ../desktop/i3.nix
    ../desktop/applications.nix

    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  #nix.nixPath = [ "nixpkgs=/home/pbb/proj/nixpkgs" "nixos=/home/pbb/proj/nixpkgs" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # taken from hardware-configuration.nix
  boot.initrd.availableKernelModules = [ "aes_x86_64" "aesni_intel" "cryptd" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1f8bf17d-9ae0-469d-a353-7cee2f30d97f";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptRoot".device = "/dev/disk/by-uuid/fb3f40fc-7d82-4b78-8e3e-7bf813b1d567";

  fileSystems."/boot"  = {
    device = "/dev/disk/by-uuid/5342-86C8";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/98d4977b-0599-4966-bffa-dd2db73951c5";} ];

  nix.maxJobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "KloenkX";
  networking.wireless.enable = true;
  #networking.wireless.networks = secrets.wifiNetworks;
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

  nixpkgs.config.allowUnfree = true; # allow unfree software

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";
}
