{ config, pkgs, ... }:

let 
  i3-package = pkgs.i3;
in {
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  services.xserver = {
    enable = true;
    libinput.enable = true;
    libinput.tappingDragLock = true;
    windowManager.i3.enable = true;
    windowManager.i3.package = i3-package;
    displayManager.startx.enable = true;
  };

  home-manager.users.kloenk = {
    home.keyboard.layout = "de";
    #home.keyboard.variant = "neo";
    home.keyboard.model = "thinkpad";
    home.keyboard.options = [ "altwin:swap_lalt_lwin" ];
    
    # files
    home.file.".wallpaper-image".source = ./wallpaper-image;
    home.file.".config/i3status/config".source = ./i3status-config;

    xsession = {
      enable = true;
      scriptPath = ".xinitrc";
      windowManager.i3 = {
        enable = true;
        package = i3-package;
        config.keybindings = {
          "Mod4+Return" = "exec ${pkgs.termite}/bin/termite";
          "Mod4+Shift+x" = "kill";
          #"Mod4+d" = "exec rifo";
          #"Mod4+p" = "exec rifopass";
          #"Mod4+Control+p" = "exec rifopass fill-in";
          #"Mod4+Control+Shift+p" = "exec rifopass username fill-in";
          "Mod4+SHift+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show drun";
          #"Mod4+z" = "exec ~/.lock.sh";
          #"Mod1+F4" = "exec ~/lock.sh";
          "XF86ScreenSave" = "exec ${pkgs.xtrlock-pam}/bin/xtrlock";
          #"Mod4+Control+z" = "exec systemd-inhibit --what=handle-lid-switch ~/.lock.sh";
          #"Mod4+Shift+z" = "exec ~/suspend.sh";
          "Mod4+t" = "exec ${pkgs.tdesktop}/bin/telegram-desktop";

          # change focus
          "Mod4+j" = "focus left";
          "Mod4+k" = "focus down";
          "Mod4+l" = "focus up";
          "Mod4+odiaeresis" = "focus right";
        
          "Mod4+Left" = "focus left";
          "Mod4+Down" = "focus down";
          "Mod4+Up" = "focus up";
          "Mod4+Right" = "focus right";

          # move focused window
          "Mod4+Shift+j" = "move left";
          "Mod4+Shift+k" = "move down";
          "Mod4+Shift+l" = "move up";
          "Mod4+Shift+odiaeresis" = "move right";

          "Mod4+Shift+Left" = "move left";
          "Mod4+Shift+Down" = "move down";
          "Mod4+Shift+Up" = "move up";
          "Mod4+Shift+Right" = "move right";

          # split in horizonal
          "Mod4+h" = "split h";

          # verticat
          "Mod4+v" = "split v";

          #fullscreen
          "Mod4+f" = "fullscreen toogle";

          # change container layout (stacked, tabbed, toggle split)
          "Mod4+s" =  "layout stacking";
          "Mod4+w" =  "layout tabbed";
          "Mod4+e" =  "layout toggle split";

          # toggle tiling / floating
          "Mod4+Shift+space" = "floating toggle";
          "button3" =  "floating toggle";
          "Mod4+button3" =  "floating toggle";

          # switch to workspace
          "Mod4+1" =  "workspace number 1";
          "Mod4+2" =  "workspace number 2";
          "Mod4+3" =  "workspace number 3";
          "Mod4+4" =  "workspace number 4";
          "Mod4+5" =  "workspace number 5";
          "Mod4+6" =  "workspace number 6";
          "Mod4+7" =  "workspace number 7";
          "Mod4+8" =  "workspace number 8";
          "Mod4+9" =  "workspace number 9";
          "Mod4+0" =  "workspace number 10";
          "Mod4+Control+1" = "workspace number 11";
          "Mod4+Control+2" = "workspace number 12";
          "Mod4+Control+3" = "workspace number 13";
          "Mod4+Control+4" = "workspace number 14";
          "Mod4+Control+5" = "workspace number 15";
          "Mod4+Control+6" = "workspace number 16";
          "Mod4+Control+7" = "workspace number 17";
          "Mod4+Control+8" = "workspace number 18";
          "Mod4+Control+9" = "workspace number 19";
          "Mod4+Control+0" = "workspace number 20";

          # move focused container to workspace
          "Mod4+Shift+1" = "move container to workspace number 1";
          "Mod4+Shift+2" = "move container to workspace number 2";
          "Mod4+Shift+3" = "move container to workspace number 3";
          "Mod4+Shift+4" = "move container to workspace number 4";
          "Mod4+Shift+5" = "move container to workspace number 5";
          "Mod4+Shift+6" = "move container to workspace number 6";
          "Mod4+Shift+7" = "move container to workspace number 7";
          "Mod4+Shift+8" = "move container to workspace number 8";
          "Mod4+Shift+9" = "move container to workspace number 9";
          "Mod4+Shift+0" = "move container to workspace number 10";
          "Mod4+Control+Shift+1" = "move container to workspace number 11";
          "Mod4+Control+Shift+2" = "move container to workspace number 12";
          "Mod4+Control+Shift+3" = "move container to workspace number 13";
          "Mod4+Control+Shift+4" = "move container to workspace number 14";
          "Mod4+Control+Shift+5" = "move container to workspace number 15";
          "Mod4+Control+Shift+6" = "move container to workspace number 16";
          "Mod4+Control+Shift+7" = "move container to workspace number 17";
          "Mod4+Control+Shift+8" = "move container to workspace number 18";
          "Mod4+Control+Shift+9" = "move container to workspace number 19";
          "Mod4+Control+Shift+0" = "move container to workspace number 20";

          #move worksapce between screens
          "Mod4+Control+h" = "move workspace to output left";
          "Mod4+Control+j" = "move workspace to output down";
          "Mod4+Control+k" = "move workspace to output up";
          "Mod4+Control+l" = "move workspace to output right";

          # reload the configuration file
          "Mod4+Shift+c" = "reload";
          # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
          "Mod4+Shift+r" = "restart";
          # exit i3 (logs you out of your X session)
          "Mod4+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"";

          "Mod4+r" = "mode \"resize\"";

          # sound
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1000";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1000";
          "XF86AudioNext" =  "exec playerctl next";
          "XF86AudioPrev" =  "exec playerctl previous";
          "XF86AudioPlay" =  "exec playerctl play-pause";
          "XF86AudioStop" =  "exec playerctl pause";
          "Mod4+XF86Display" = "exec ${pkgs.xorg.xrandr}/bin/xrandr --auto";
        };
        config.bars = [{
          fonts = [ "DejaVu Sans Mono 11" ];
          position = "top";
          command = "${i3-package}/bin/i3bar -t"; # support transparency
          colors = {
            background = "#00000000";
            inactiveWorkspace = { border = "#323232ff"; background = "#323232ff"; text = "#ffffffff"; };
            focusedWorkspace = { border = "#ffffffff"; background = "#ffffffff"; text = "#000000ff"; };
          };
        }];
        extraConfig = ''
          for_window [class="^.*"] border pixel 0
          workspace_auto_back_and_forth yes

          for_window [window_role="pop-up"] floating enable
          for_window [title="rifo-fzf-choose"] floating enable

          # plasma stuff
          exec --no-startup-id wmctrl -c Plasma
          for_window [title="Desktop — Plasma"] kill; floating enable; border none

          # auto switch
          force_display_urgency_hint 0 ms
          focus_on_window_activation urgent

          ## Avoid tiling popups, dropdown windows from plasma
          # for the first time, manually resize them, i3 will remember the setting for floating windows
          for_window [class="plasmashell"] floating enable
          for_window [class="Plasma"] floating enable, border none
          for_window [title="plasma-desktop"] floating enable, border none
          for_window [title="win7"] floating enable, border none
          for_window [class="krunner"] floating enable, border none
          for_window [class="Kmix"] floating enable, border none
          for_window [class="Klipper"] floating enable, border none
          for_window [class="Plasmoidviewer"] floating enable, border none
        '';
      };
      initExtra = ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
        ${pkgs.feh}/bin/feh --bg-fill ~/wallpaper-image

        export XDB_SESSION_TYPE=x11
        export KDE_FULL_SESSION=true
        export XDG_CURRENT_DESKTOP=KDE
        export GPG_TTY=$(tty)

        ${pkgs.notify-osd}/usr/lib/notify-osd/notify-osd &
        ${pkgs.blueman}/bin/blueman-applet &
        ${pkgs.pasystray}/bin/pasystray &
      '';
    };

    services.compton = {
      enable = true;
      backend = "glx";
      shadow = "true";
      shadowOpacity = "0.3";
    };

    services.redshift = {
      enable = true;
      latitude = "51.085636";
      longitude = "7.1105932";
      #temperature = {
        #day = 5500;
        #night = 3700;
      #};
    };
  };

  fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji source-code-pro ];
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
}