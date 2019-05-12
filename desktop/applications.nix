{ config, pkgs, ... }:

{
  imports = [
    ./kde.nix
  ];

  home-manager.useUserPackages = true;

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
    vscode-with-extensions
    mosh
    chromium
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
  hardware.steam-hardware.enable = true;

  home-manager.users.kloenk.programs.git.extraConfig.signing = {
        key = "0xC9546F9D";
        signByDefault = true;
  };

  #home-manager.users.kloenk.programs.vscode ={
  #    enable = true;
  #    userSettings = {
  #      "files.autoSave" = "afterDelay";
  #      "git.autofetch" = true;
  #      "workbench.startupEditor" = "newUntitledFile";
  #      "todo-tree.defaultHighlight" = {
  #        "icon" = "alert";
  #        "type" = "text";
  #        "foreground" = "red";
  #        "background" = "white";
  #        "opacity" = 50;
  #        "iconColour" = "blue";
  #      };
  #      "workbench.colorTheme" = "Visual Studio Dark";
  #      "git-graph.fetchAvatars" = true;
  #    };
  #    extensions = [
  #      "bungcip.better-toml"
  #      "ms-vscode.cpptools"
  #      "serayuzgur.crates"
  #      "lunaryorn.fish-ide"
  #      "waderyan.gitblame"
  #      "mhutchie.git-graph"
  #      "eamodio.gitlens"
  #      "bbenoist.nix"
  #      "martinring.nix"
  #      "platformio.platformio-ide"
  #      "alefragnani.project-manager"
  #      "rust-lang.rust"
  #      "swellaby.rust-pack"
  #      "gruntfuggly.todo-tree"
  #    ];
  #  };
}
