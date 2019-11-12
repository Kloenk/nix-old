{ config, pkgs, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
  manager = import ./manager { pkgs = pkgs; };
in {
  imports = [
  ];
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    termite.terminfo
    kitty.terminfo
    rxvt_unicode.terminfo
    restic
  ];

  environment.variables.EDITOR = "vim";

  users.mutableUsers = false; # disallow change of users by user
  users.users.kloenk = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "bluetooth"
      "libvirt"
    ];
    shell = pkgs.fish;
    hashedPassword = secrets.hashedPasswords.kloenk;
    packages = with pkgs; [
      wget
      vim
      tmux
      nload
      htop
      rsync
      ripgrep
      exa
      bat
      progress
      pv
      parallel
      skim
      file
      git
      elinks
      bc
      zstd
      usbutils
      pciutils
      mediainfo
      ffmpeg_4
      mktorrent
      unzip
      gptfdisk
      jq
      nix-prefetch-git
      pass-otp
      gopass
      neofetch
      # dovecot_pigeonhole
      sl
      exa
      todo-txt-cli
      #llvmPackages.bintools
    ];
  };

  home-manager.users.kloenk = {
    #home.file.".terminfo".source = "/run/current-system/etc/terminfo";

    programs = manager.programs;

    services = manager.services;
  };

  programs.fish.enable = true;
  programs.mtr.enable = true;
  users.users.root.shell = pkgs.fish;
}
