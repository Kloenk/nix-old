{ config, pkgs, ... }:

let
    script = pkgs.writeTextFile { 
        name = "monitor-setup";
        text = ''
#!${pkgs.bash}/bin/bash


# NB: you will need to modify the username and tweak the xrandr
# commands to suit your setup.

KERNEL_SHOW_NAME="docking_udev"
username=kloenk

# wait for the dock state to change
${pkgs.coreutils}/bin/sleep 0.5
export DISPLAY=:0

if [[ -z "$ACTION" ]]; then
        ACTION="$1"
fi

if [[ "$ACTION" == "add" ]]; then
  DOCKED=1
  ${pkgs.utillinux}/bin/logger-t $KERNEL_SHOW_NAME "Detected condition: docked"
elif [[ "$ACTION" == "remove" ]]; then
  DOCKED=0
  ${pkgs.utillinux}/bin/logger-t $KERNEL_SHOW_NAME "Detected condition: un-docked"
else
  ${pkgs.utillinux}/bin/logger-t $KERNEL_SHOW_NAME "Detected condition: unknown"
  echo Please set env var \$ACTION to 'add' or 'remove'
  ${pkgs.utillinux}/bin/logger-t $KERNEL_SHOW_NAME "Pleas set env var \$ACTION to 'add' or 'remove'"
  exit 1
fi

# invoke from XSetup with NO_KDM_REBOOT otherwise you'll end up in a KDM reboot loop
NO_KDM_REBOOT=0
for p in $*; do
  case "$p" in
  "NO_KDM_REBOOT") NO_KDM_REBOOT=1 ;;
  "SWITCH_TO_LOCAL") DOCKED=0 ;;
  esac
done

function switch_to_local {
        ${pkgs.utillinux}/bin/logger-t $KERNEL_SHOW_NAME "set LVDS1 to on"
        su $username -c '${pkgs.xorg.xrandr}/bin/xrandr \
                --output DP-3 --off \
                --output DP-2 --off \
                --output DP-1 --off \
                --output HDMI-3 --off \
                --output HDMI-2 --off \
                --output HDMI-1 --off \
                --output LVDS-1 --primary --mode 1366x768 --pos 0x0 --rotate normal \
                --output VGA-1 --off
          '
          su $username -c 'feh --bg-fill ~/.wallpaper.png'
          su $username -c 'setxkbmap de'        # to prevent errors with external keyboard
}

function switch_to_external {
        ${pkgs.utillinux}/bin/logger-t $KERNEL_SHOW_NAME "set HDMI3 & LVDS1 to on"
        su $username -c '${pkgs.xorg.xrandr}/bin/xrandr \
                --output VIRTUAL-1 --off \
                --output DP-3 --off \
                --output DP-2 --mode 1920x1080 --pos 1920x304 --rotate normal \
                --output DP-1 --off \
                --output HDMI-3 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
                --output HDMI-2 --off \
                --output HDMI-1 --off \
                --output LVDS-1 --off \
                --output VGA-1 --off
          '
          su $username -c 'feh --bg-fill ~/.wallpaper.png'
          su $username -c 'setxkbmap de'        # to prevent errors with external keyboard
}

case "$DOCKED" in
  "0")
    #undocked event
    switch_to_local :0 ;;
  "1")
    #docked event
    switch_to_external :0 ;;
esac
    '';
    executable = true; }; 
in {
    services.udev = {
        extraRules = ''
SUBSYSTEM=="usb", ACTION=="add|remove", ENV{PRODUCT}=="17ef/100a/0", RUN+="${script}"
        '';
    };
}