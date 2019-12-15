{ config, pkgs, lib, ... }:

let
  #secrets = import /etc/nixos/secrets.nix;
in {
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix

    ../../default.nix
    ../../common
    ../../desktop/sway.nix
    ../../desktop
    #../desktop/spotifyd.nix
    #../../common/collectd.nix

  ];

  environment.variables.NIX_PATH = lib.mkForce "/var/src";

  services.logind.lidSwitchDocked = "ignore";

  boot.tmpOnTmpfs = true;

  networking.hostName = "KloenkX";
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp2s0" ];
  networking.wireless.networks = import <secrets/wifi.nix>;
  networking.wireless.userControlled.enable = true;
  networking.extraHosts = ''
    172.16.0.1 airlink.local unit.local
    192.168.43.2  git.yougen.de grafana.yougen.de netbox.yougen.de
    192.168.42.6 kloenkX.kloenk.de
  '';
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.bonds."bond0" = {
    interfaces = [ "eno0" "wlp2s0" ];
  };

  

  security.sudo.extraConfig = ''
    collectd ALL=(root) NOPASSWD: ${pkgs.wireguard-tools}/bin/wg show all transfer
  '';

  #services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.xtrlock-pam.fprintAuth = true;

  services.printing.browsing = true;
  services.printing.enable = true;
  services.avahi.enable = true;

  #services.collectd2.extraConfig = ''
  #  LoadPlugin exec
#
  #  <Plugin exec>
  #    Exec collectd "${pkgs.collectd-wireguard}/bin/collectd-wireguard"
  #  </Plugin>
  #'';

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
  security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice_gtk}/bin/spice-client-glib-usb-acl-helper";

  environment.systemPackages = with pkgs; [
    spice_gtk
    davfs2
    geogebra
    gtk-engine-murrine
    tango-icon-theme
    breeze-icons
    gnome3.adwaita-icon-theme
  ];

  services.xserver.wacom.enable = true;
  services.xserver.config = ''
    Section "InputClass"
        Identifier	"calibration"
        MatchProduct	"Wacom ISDv4 90 Pen stylus"
        Option	"MinX"	"69"
        Option	"MaxX"	"27558"
        Option	"MinY"	"193"
        Option	"MaxY"	"15654"
    EndSection
  '';

  # make autoupdates
  #system.autoUpgrade.enable = true;

  #services.logind.lidSwitch = "ignore";
  services.tlp.enable = true;
  users.users.kloenk.initialPassword = "foobaar";
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
    steam
    steamcontroller    

    # minecraft
    multimc

    # docker controller
    docker
    virtmanager

    # paint software
    krita
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

  # ssh key from yg-adminpc
  users.users.kloenk.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhvJ6hdf4pgsFl8c5lMuDAzUVmJwtSY/O66nDDRAK6J kloenk@adminpc" ];

  services.udev.packages = [ pkgs.openocd ];

  services.dbus.socketActivated = true;

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
  #services.collectd2.plugins = {
  #  network.options.Server = "51.254.249.187";
  #  sensors.hasConfig = false;
  #  processes.hasConfig = false;
  #  virt.options = {
  #    Connection = "qemu:///system";
  #    HostnameFormat = "name";
  #  };
  #};

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";
}
