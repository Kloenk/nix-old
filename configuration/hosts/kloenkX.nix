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
    ../collectd.nix

    # x230 configuration
    <nixos-hardware/lenovo/thinkpad/x230> 
    # fallback for detection
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  #nix.nixPath = [ "nixpkgs=/home/pbb/proj/nixpkgs" "nixos=/home/pbb/proj/nixpkgs" ];

  hardware.cpu.intel.updateMicrocode = true;

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";

  # f2fs support
  boot.supportedFilesystems = [ "f2fs" "ext2" "nfs" "cifs" ];

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
  boot.extraModulePackages = [
    config.boot.kernelPackages.acpi_call
    config.boot.kernelPackages.tp_smapi
    config.boot.kernelPackages.wireguard
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b5265276-b78f-45d0-a34e-2775467766f5";
      fsType = "f2fs";
    };

  boot.initrd.luks.devices."cryptRoot".device = "/dev/disk/by-uuid/5faab799-5559-452b-af82-d169f21a4d00";

  fileSystems."/boot"  = {

    device = "/dev/disk/by-uuid/09e9d51a-eb4c-4baa-aff7-7f7df01c8bad";
    fsType = "ext2";
  };

  swapDevices = [
    { device = "/dev/disk/by-id/ata-SAMSUNG_MZ7WD240HAFV-00003_S16LNYADB02059-part1"; randomEncryption= { enable = true; source = "/dev/random"; }; }
    { device = "/dev/disk/by-id/ata-SAMSUNG_SSD_PM871_mSATA_128GB_S20FNXAGC19931-part2"; randomEncryption= { enable = true; source = "/dev/random"; }; }
  ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  # set battery threshold
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

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.42.6/24" ];
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
    vscode-with-extensions # code editor (unfree :-( )
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

    # docker controller
    docker
  ];

  nixpkgs.config.packageOverrides = pkgs: rec {
    vscodeCpp = pkgs.vscode-with-extensions.override {
      vscodeExtensions = vscode-extensions: with vscode-extensions;[ ms-vscode.cpptools ];
    };
  };

  # docker fo
  virtualisation.docker.enable = true;

  users.users.kloenk.extraGroups = [
    "dialout"  # allowes serial connections
    "plugdev"  # allowes stlink connection
    "davfs2"   # webdav foo
    "docker"   # docker controll group
  ];

  services.udev.packages = [ pkgs.openocd ];

  services.pcscd.enable = true;
  #services.pcscd.plugins = with pkgs; [ ccid pcsc-cyberjack ];


  nixpkgs.config.allowUnfree = true; # allow unfree software
  #nixpkgs.config.allowBroken = true; # for WideVine
  #nixpkgs.config.chromium.enableWideVine = true;

  hardware.bluetooth.enable = true;

  # add bluetooth sink
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";
}
