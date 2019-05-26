{ config, pkgs, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
  imports = [
    ../../default.nix
    ../users.nix
    ../ssh.nix
    ../server/prometheus.nix
    ../server/grafana.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "vm";
  

  services.vnstat.enable = true;
  system.autoUpgrade.enable = true;

  system.stateVersion = "19.03";
}