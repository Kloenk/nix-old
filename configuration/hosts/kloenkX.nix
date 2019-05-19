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

    # x230 configuration
    <nixos-hardware/lenovo/thinkpad/x230> 
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
  boot.kernelModules = [ "kvm-intel" ];
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

  # make autoupdates
  system.autoUpgrade.enable = true;

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
    teamspeak_client       # team speak

    # steam
    steam
    steamcontroller    
  ];

  nixpkgs.config.packageOverrides = pkgs: rec {
    vscodeCpp = pkgs.vscode-with-extensions.override {
      vscodeExtensions = vscode-extensions: with vscode-extensions;[ ms-vscode.cpptools ];
    };
  };

  services.pcscd.enable = true;
  #services.pcscd.plugins = with pkgs; [ ccid pcsc-cyberjack ];

  fileSystems."/media/MNS" = {
      device = "//10.1.0.1/FinBeh$";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/secrets/mns-smb.secrets"];
  };

  fileSystems."/media/Filme" = {
    device = "192.168.178.248:Filme";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s"];
  };

  fileSystems."/media/TapeDrive" = {
    device = "192.168.178.248:TapeDrive";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s"];
  };

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
