{ config, pkgs, ...}:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    # user files
    ../ssh.nix
    ../users.nix
    ../desktop/xmonad.nix
    ../desktop/applications.nix
    ../collectd.nix
    ../../default.nix
  ];

  networking.hostName = "iso";
  networking.wireless.enable = true;
  
  users.users.kloenk.packages = with pkgs; [
    lm_sensors
    tpacpi-bat
    acpi                   # fixme: not in the kernel
    wine                   # can we ditch it?
    firefox                # used because of netflix :-(
    spotifywm              # spotify fixed for wms
    python                 # includes python2 as dependency for vscode
    teamspeak_client       # team speak

    # steam
    steam
    steamcontroller    

    # minecraft
    multimc

    # docker controller
    docker
    virtmanager
  ];

  hardware.bluetooth.enable = true;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";
}