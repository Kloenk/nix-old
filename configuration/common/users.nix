{ config, pkgs, lib, ... }:

let
  #secrets = import <secrets>;
in {
  imports = [
  ];
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "neo";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    termite.terminfo
    kitty.terminfo
    rxvt_unicode.terminfo
    restic
  ];

  security.sudo.wheelNeedsPassword = false;

  environment.variables.EDITOR = "vim";

  users.mutableUsers = true; # disallow change of users by user
  users.users.kloenk = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "bluetooth"
      "libvirt"
    ];
    shell = pkgs.fish;
    initialPassword = "foobaar";
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
      sl
      exa
      todo-txt-cli
      #llvmPackages.bintools
    ];
  };

  home-manager.users.kloenk = {
    programs = {
      git = {
        enable = true;
        userName = "Finn Behrens";
        userEmail = "me@kloenk.de";
        extraConfig = {
          core.editor = "${pkgs.vim}/bin/vim";
          color.ui = true;
        };
      };

      fish = {
        enable = true;
        shellInit = ''
          set PAGER less
        '';
        shellAbbrs = {
          admin-YouGen = "ssh admin-yougen";
          cb = "cargo build";
          cr = "cargo run";
          ct = "cargo test";
          exit = " exit";
          gc = "git commit";
          gis = "git status";
          gp = "git push";
          hubble = "mosh hubble";
          ipa = "ip a";
          ipr = "ip r";
          s = "sudo";
          ssy = "sudo systemctl";
          sy = "systemctl";
          v = "vim";
          jrnl = " jrnl";
        };
        shellAliases = {
          ls = "exa";
          l = "exa -a";
          ll = "exa -lgh";
          la = "exa -lagh";
          lt = "exa -T";
          lg = "exa -lagh --git";
        };
      };

      ssh = {
        enable = true;
        forwardAgent = false;
        controlMaster = "auto";
        controlPersist = "15m";
        matchBlocks = {
          hubble = {
            hostname = "kloenk.de";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          hubble-encrypt = {
            hostname = "51.254.249.187";
            port = 62954;
            user = "root";
            forwardAgent = false;
            identityFile = toString <secrets/id_rsa>;
            checkHostIP = false;
            extraOptions = { "UserKnownHostsFile" = "/dev/null"; };
          };
          lycus = {
            hostname = "10.0.0.4";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          admin-yougen = {
            hostname = "10.66.6.42";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          admin-yougen-io = {
            hostname = "10.66.6.42";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
            proxyJump = "io-llg0";
          };
          pluto = {
            hostname = "10.0.0.3";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          pluto-io = {
            hostname = "10.0.0.3";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
            proxyJump = "io-llg0";
          };
          io = {
            hostname = "10.0.0.2";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          io-llg0 = {
            hostname = "192.168.43.2";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          atom = {
            hostname = "192.168.178.248";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          atom-wg = {
            hostname = "192.168.42.7";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
          kloenkX-fritz = {
            hostname = "192.168.178.43";
            port = 62954;
            user = "kloenk";
            forwardAgent = true;
          };
        };
      };

      vim = {
        enable = true;
      };
    };

    services = {
      gpg-agent = {
        enable = true;
        defaultCacheTtl = 300; # 5 min
        defaultCacheTtlSsh = 600; # 10 min
        maxCacheTtl = 7200; # 2h
      };
    };
  };

  programs.fish.enable = true;
  programs.mtr.enable = true;

  users.users.root.shell = pkgs.fish;
}
