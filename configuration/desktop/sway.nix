{ pkgs, ... }:

{
  programs.sway.enable = true;
  programs.sway.extraSessionCommands = ''
    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    #export GDK_BACKEND=wayland
  '';

  users.users.kloenk.packages = with pkgs; [
    wofi
    mako
    waybar
  ];

  home-manager.users.kloenk = {
    xdg.configFile."sway/config".source = ./config.sway;
  };
}
