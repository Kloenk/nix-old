{ config, pkgs, ... }:

let 

in {
    services.xserver = {
        enable = true;
        libinput.enable = true;
        libinput.tappingDragLock = true;
        displayManager.startx.enable = true;
    };

    services.dbus.packages = with pkgs; [ gnome3.dconf ];

    home-manager.users.kloenk = {
        home.keyboard.layout = "de";
        home.keyboard.options = [ "altwin:swap_lalt_lwin" ];

        home.file.".wallpaper-image-hdmi".source = ./wallpaper-image-hdmi.png;
        home.file.".wallpaper-image".source = ./wallpaper-image;
        home.file.".config/quassel-irc.org/Dracula.qss".source = ./Dracula.qss;
        home.file.".Xresources".source = ./Xresources;

        xsession = {
            enable = true;
            scriptPath = ".xinitrc";
            windowManager.command = "${pkgs.dwm}/bin/dwm";
            initExtra = ''
                ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
                ${pkgs.feh}/bin/feh --bg-fill ~/.wallpaper-image
                ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &

                export XDB_SESSION_TYPE=x111
                export KDE_FULL_SESSION=true
                export XDG_CURRENT_DESKTOP=KDE
                export GPG_TTY=$(tty)

                ${pkgs.notify-osd}/usr/lib/notify-osd/notify-osd &

                ${pkgs.slstatus}/bin/slstatus &
            '';
            #    ${pkgs.blueman}/bin/blueman-applet &
            #    ${pkgs.pasystray}/bin/pasystray &
            #'';
        };

        services.compton = {
            enable = true;
            backend = "glx";
            shadow = true;
            shadowOpacity = "0.3";
        };

        services.redshift = {
            enable = true;
            latitude = "51.085636";
            longitude = "7.1105932";
        };

        programs.fish.shellAbbrs = {
            startx = "exec startx";
        };

        programs.rofi = {
            enable = true;
            padding = 15;
            font = "DejaVu Sans 13";
            scrollbar = false;
            terminal = "${pkgs.termite}/bin/termite";
            #colors = {
            #    window = {
            #        background = "argb:e0000000";
            #        border = "argb:00000000";
            #        separator = "argb:00000000";
            #    };
            #    rows = {
            #        normal = {
            #            background = "argb:00000000";
            #            foreground = "#ffffff";
            #            backgroundAlt = "argb:00000000";
            #            highlight.background = "argb:00000000";
            #            highlight.foreground = "#567eff";
            #        };
            #    };
            #};
            theme = "${pkgs.rofi}/share/rofi/themes/Arc-Dark.rasi";
            extraConfig = ''
                rofi.fake-transparency: true
                rofi.show-icons: true
                rofi.modi: combi,drun,ssh,window
                rofi.combi-modi: drun,ssh,window
                rofi.sidebar-mode: true
                rofi.auto-select: false
                rofi.ssh-command: ${pkgs.termite}/bin/termite -e "${pkgs.openssh}/bin/ssh {host}"

                rofi.color-window:      argb:e0000000,argb:00000000,argb:00000000
                rofi.color-normal:      argb:00000000,#ffffff,argb:00000000,argb:00000000,#567eff
            '';
        };
    };

    fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji source-code-pro ];
    programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
}
