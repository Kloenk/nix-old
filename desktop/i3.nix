{ config, pkgs, ... }:

let
  dotfiles = import ../dotfiles/default.nix { inherit pkgs; };

in {
  users.users.kloenk.packages = with pkgs; [
    dotfiles
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbVariant = "";
  services.xserver.libinput.enable = true;
  services.xserver.libinput.tappingDragLock = false;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.displayManager.startx.enable = true;

  services.redshift = {
    enable = true;
    latitude = "51.085636";
    longitude = "7.1105932";
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  services.compton = {
    enable = true;
  };

  fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji source-code-pro ];

  programs.ssh.startAgent = true;
  programs.browserpass.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
}
