{ pkgs, ... }:

''
  #!${pkgs.stdenv.shell}
  ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
  ${pkgs.feh}/bin/feh --bg-fill ~/.wallpaper.png
  ${pkgs.compton}/bin/compton -b
  ${pkgs.redshift}/bin/redshift -l52.31:13.24 &

  export GPG_TTY=$(tty)
  export XDG_CURRENT_DESKTOP=KDE
	export XDB_SESSION_TYPE=X11
	export KDE_FULL_SESSION=true

  ${pkgs.notify-osd}/usr/lib/notify-osd/notify-osd &
  ${pkgs.blueman}/bin/blueman-applet &
  ${pkgs.pasystray}/bin/pasystray &

  exec ${pkgs.i3-gaps}/bin/i3
''

