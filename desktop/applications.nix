{ config, pkgs, ... }:

{
  users.users.kloenk.packages = with pkgs; [
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
    thunderbird
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
    pass
    pass-otp
    vscode # or vscode-with-extensions
    mosh
  ];

  nixpkgs.config.allowUnfree = true;

  users.users.kloenk.extraGroups = [ "wireshark" "adbusers" "nitrokey" ];
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark-gtk;
  nixpkgs.config.android_sdk.accept_license = true;
  programs.adb.enable = true;
  programs.chromium = { enable = true; extensions = [
    "cfhdojbkjhnklbpkdaibdccddilifddb" # ad block plus
    "kbfnbcaeplbcioakkpcpgfkobkghlhen" # gramarly
    "ppmmlchacdbknfphdeafcbmklcghghmd" # jwt debugger
    "laookkfknpbbblfpciffpaejjkokdgca" # momentum
    "pdiebiamhaleloakpcgmpnenggpjbcbm" # tab snooze
  ]; };
  hardware.nitrokey.enable = true;
  hardware.steam-hardwar.enable = true;
}
