{ config, pkgs, ... }:

{
  home-manager.useUserPackages = true;

  users.users.kloenk.packages = with pkgs; [
    arandr
    flameshot
    rustup
    gcc
    yarn
    nodejs-10_x
    python3

    gnupg
    xournal
    ansible
    arcanist
    ncat
    pwgen
    mpc_cli
    powertop
    qemu
    gnome3.gnome-clocks
    gnome3.quadrapassel
    imagemagick
    gimp
    inkscape
    krita
    sshfs
    quasselClient
    pavucontrol
    gnupg
    mpv
    tdesktop
    evince
    youtubeDL
    #mumble
    calcurse
    neomutt
    bind # for dig
    screen # for usb serial
    pass-otp
    mosh
    chromium
    libreoffice
    blueman
    mkpasswd
    lxappearance

    # java
    jre8_headless

    # Archives (e.g., tar.gz and zip)
    ark

    # This is needed for graphical dialogs used to enter GPG passphrases
    pinentry_qt5

    # mail
    thunderbird

    # picture viewving
    sxiv
    feh

    # audio
    audacity

    # KiCad pcb layout tool
    kicad
  ];


  users.users.kloenk.extraGroups = [ "wireshark" "adbusers" "nitrokey" ];
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark-qt;
  nixpkgs.config.android_sdk.accept_license = true;
  programs.adb.enable = true;
  programs.chromium = { enable = true; extensions = [
      "cfhdojbkjhnklbpkdaibdccddilifddb" # ad block plus
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # gramarly
      "ppmmlchacdbknfphdeafcbmklcghghmd" # jwt debugger
      "laookkfknpbbblfpciffpaejjkokdgca" # momentum
      "pdiebiamhaleloakpcgmpnenggpjbcbm" # tab snooze
    ];
  };
  hardware.nitrokey.enable = true;

  # steam hardware
  hardware.steam-hardware.enable = true;
  hardware.opengl.driSupport32Bit = true;

  home-manager.users.kloenk.programs.git.signing = {
        key = "0xC9546F9D";
        signByDefault = true;
  };


  home-manager.users.kloenk.home.file.".config/VSCodium/User/settings.json".source = ./code-settings.json;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;

    # extra codes for pulseaudio bluetooth
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };
  nixpkgs.config.pulseaudio = true;
}
