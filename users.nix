{ config, pkgs, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in {
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    termite.terminfo
    rxvt_unicode.terminfo
  ];

  users.users.kloenk = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
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
      # dovecot_pigeonhole
    ];
  };

  programs.fish.enable = true;
  programs.mtr.enable = true;
  users.users.root.shell = pkgs.fish;
}
