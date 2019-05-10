{ pkgs ? import <nixpkgs> {}, ... }:

let
  i3Config = pkgs.writeText "kloenk-i3-config" (import ./i3.nix { inherit pkgs; });
  i3statusConfig = pkgs.writeText "kloenk-i3status-config" (import ./i3status.nix { inherit pkgs; });
  vimrc = pkgs.writeText "kloenk-vimrc" (import ./vimrc.nix { inherit pkgs; });
  xinitrc = pkgs.writeText "kloenk-xinitrc" (import ./xinitrc.nix { inherit pkgs; });
  xresources = pkgs.writeText "kloenk-xresources" (import ./xresources.nix { inherit pkgs; });
  fishconfig = pkgs.writeText "kloenk-fish-config" ( import ./fish.nix { inherit pkgs; });

in
  pkgs.stdenv.mkDerivation {
    name = "kloenk-dotfiles";

    src = ./.;

    buildPhase = "";

    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/install-dotfiles <<EOF
      #!${pkgs.stdenv.shell}
      mkdir -p ~/.config/i3
      mkdir -p ~/.config/i3status
      mkdir -p ~/.config/fish
      ln -sf /run/current-system/etc/terminfo ~/.terminfo
      ln -sf ${i3Config} ~/.config/i3/config
      ln -sf ${i3statusConfig} ~/.config/i3status/config
      ln -sf ${vimrc} ~/.vimrc
      ln -sf ${xinitrc} ~/.xinitrc
      ln -sf ${xresources} ~/.Xresources
      ln -sf ${fishconfig} ~/.config/fish/config.fish
      EOF
      chmod +x $out/bin/install-dotfiles
    '';
  }
