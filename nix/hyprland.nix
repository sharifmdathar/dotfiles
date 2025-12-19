{
  config,
  pkgs,
  lib,
  helium-browser,
  ...
}:

let
  mainMod = "SUPER";
  toggleKbdScript = pkgs.writeShellScriptBin "toggle-kbd-script" ''
    current_brightness=$(${pkgs.brightnessctl}/bin/brightnessctl --device='rgb:kbd_backlight' get)
    if [ "$current_brightness" -eq 0 ]; then
      ${pkgs.brightnessctl}/bin/brightnessctl --device='rgb:kbd_backlight' set 50%
    else
      ${pkgs.brightnessctl}/bin/brightnessctl --device='rgb:kbd_backlight' set 0%
    fi
  '';
  toggleCaffeineScript = pkgs.writeShellScriptBin "toggle-caffeine" ''
    if systemctl --user is-active --quiet caffeine; then
      systemctl --user stop caffeine
      ${pkgs.libnotify}/bin/notify-send -i dialog-information "Caffeine" "Disabled. Screen can sleep."
    else
      systemctl --user start caffeine
      ${pkgs.libnotify}/bin/notify-send -i dialog-information "Caffeine" "Enabled. Screen will stay awake."
    fi
  '';
in

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
      };
      label = {
        text = "Locked";
        text_align = "center";
        font_family = "JetBrains Mono";
        font_size = 20;
        color = "rgba(255, 255, 255, 1.0)";
        position = "0, 0";
      };
      "input-field" = {
        size = "200, 50";
        position = "0, -50";
        outline_thickness = 2;
        dots_center = true;
        fade_on_empty = true;
        placeholder_text = "";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 60;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 120;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitorv2 = [
        {
          output = "eDP-1";
          mode = "1920x1080@60";
          position = "0x0";
          scale = 1;
          bitdepth = 10;
          cm = "auto";
        }
        {
          output = "";
          mirror = "eDP-1";
        }
      ];
      xwayland.force_zero_scaling = true;
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.8;
        shadow = {
          enabled = false;
          range = 4;
          render_power = 3;
        };
        blur = {
          enabled = false;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = false;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "us";
        numlock_by_default = true;
        touchpad.natural_scroll = true;
        follow_mouse = 1;
        sensitivity = 0;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      gestures = {
        gesture = "3, horizontal, workspace";
      };

      bind = [
        "${mainMod}, RETURN, exec, ${pkgs.alacritty}/bin/alacritty"
        "${mainMod}, Q, killactive"
        "${mainMod}, M, exit"
        "${mainMod} SHIFT, BACKSPACE, exit"
        "${mainMod}, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
        "${mainMod}, F, fullscreen, 0"
        "${mainMod} SHIFT, SPACE, togglefloating"
        "${mainMod}, J, togglesplit"
        "${mainMod}, space, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "${mainMod}, V, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi --dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
        "${mainMod}, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "${mainMod}, ESCAPE, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "${mainMod}, C, exec, ${pkgs.code-cursor}/bin/cursor"
        "${mainMod}, B, exec, ${pkgs.xdg-utils}/bin/xdg-open https://"
        "${mainMod}, X, exec, ${pkgs.wlogout}/bin/wlogout"
        "${mainMod}, T, exec, ${toggleCaffeineScript}/bin/toggle-caffeine"
        ",print, exec, ${pkgs.hyprshot}/bin/hyprshot -m output -m eDP-1"
        "shift,print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
        "${mainMod},print, exec, ${pkgs.hyprshot}/bin/hyprshot -m window"
        "${mainMod}, left, movefocus, l"
        "${mainMod}, right, movefocus, r"
        "${mainMod}, up, movefocus, u"
        "${mainMod}, down, movefocus, d"
        "${mainMod}, 1, workspace, 1"
        "${mainMod}, 2, workspace, 2"
        "${mainMod}, 3, workspace, 3"
        "${mainMod}, 4, workspace, 4"
        "${mainMod}, 5, workspace, 5"
        "${mainMod}, 6, workspace, 6"
        "${mainMod}, 7, workspace, 7"
        "${mainMod}, 8, workspace, 8"
        "${mainMod}, 9, workspace, 9"
        "${mainMod}, 0, workspace, 10"
        "${mainMod} SHIFT, 1, movetoworkspace, 1"
        "${mainMod} SHIFT, 2, movetoworkspace, 2"
        "${mainMod} SHIFT, 3, movetoworkspace, 3"
        "${mainMod} SHIFT, 4, movetoworkspace, 4"
        "${mainMod} SHIFT, 5, movetoworkspace, 5"
        "${mainMod} SHIFT, 6, movetoworkspace, 6"
        "${mainMod} SHIFT, 7, movetoworkspace, 7"
        "${mainMod} SHIFT, 8, movetoworkspace, 8"
        "${mainMod} SHIFT, 9, movetoworkspace, 9"
        "${mainMod} SHIFT, 0, movetoworkspace, 10"
        "${mainMod}, S, togglespecialworkspace, magic"
        "${mainMod} SHIFT, S, movetoworkspace, special:magic"
        "${mainMod}, TAB, cyclenext"
        "${mainMod} SHIFT, TAB, cyclenext, prev"
        "${mainMod} CTRL, left, workspace, m-1"
        "${mainMod} CTRL, right, workspace, m+1"
        ", XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, ${pkgs.swayosd}/bin/swayosd-client --device='intel_backlight' --brightness +1"
        ", XF86MonBrightnessDown, exec, ${pkgs.swayosd}/bin/swayosd-client  --device='intel_backlight' --brightness -1"
        ", XF86KbdBrightnessUp, exec, ${pkgs.swayosd}/bin/swayosd-client --device='rgb:kbd_backlight' --brightness +20"
        ", XF86KbdBrightnessDown, exec, ${pkgs.swayosd}/bin/swayosd-client --device='rgb:kbd_backlight' --brightness -20"
        ", XF86KbdLightOnOff, exec, ${toggleKbdScript}/bin/toggle-kbd-script"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ];

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "opacity 1.0,title:Picture in picture"
        "opacity 0.8,floating:1,class:^(firefox|chromium|Google-chrome|brave|mpv|vlc|floorp)$"
      ];
    };

    extraConfig = ''
      exec-once = waybar
      exec-once = udiskie
      exec-once = swayosd-server
      exec-once = wl-paste --watch cliphist store
      exec-once = systemctl --user start hyprpolkitagent
      exec-once = systemctl --user start swayosd-libinput-backend
    '';
  };
}
