{ config, pkgs, ... }:

let
  caffeineStatus = pkgs.writeShellScript "caffeine-status" ''
    if systemctl --user is-active --quiet caffeine; then
      printf '%s\n' '{"text":"☕ Caffeine","class":"on","tooltip":"Screen sleep inhibited"}'
    else
      printf '%s\n' '{"text":"☕ off","class":"off","tooltip":"Click to keep screen awake"}'
    fi
  '';
  caffeineToggle = pkgs.writeShellScript "caffeine-toggle" ''
    if systemctl --user is-active --quiet caffeine; then
      systemctl --user stop caffeine
    else
      systemctl --user start caffeine
    fi
  '';
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        modules-left = [ "hyprland/workspaces" "memory" "cpu" ];
        modules-center = [ "custom/caffeine" "clock" "hyprland/window" ]; 
        modules-right = [
          "tray"
          "bluetooth"
          "network"
          "wireplumber"
          "battery"
          "custom/notifications"
          "custom/power"
        ];

        "hyprland/window" = {
          max-length = 30;
        };

        "bluetooth" = {
          format = " {status}";
          format-disabled = "";
          format-connected = " {device_alias} ({device_battery_percentage}%)";
          max-length = 15;
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_battery_percentage}%";
          on-click = "alacritty -e bluetuith";
        };

        "custom/notifications" = {
          format = "";
          tooltip = false;
          on-click = "swaync-client -t";
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          menu = "on-click";
          menu-file = "${config.home.homeDirectory}/.config/waybar/power_menu.xml";
          menu-actions = {
            shutdown = "poweroff";
            reboot = "reboot";
            suspend = "systemctl suspend";
            hibernate = "systemctl hibernate";
          };
        };

        "cpu" = {
          format = "{usage}%  ";
          interval = 30;
        };

        "memory" = {
          format = "{percentage}% MEM";
          interval = 30;
          on-click = "alacritty -e htop";
        };

        "clock" = {
          format = "{:%a %d %H:%M}";
          tooltip-format = "{:%B %Y}";
        };

        "custom/caffeine" = {
          return-type = "json";
          interval = 3;
          exec = "${caffeineStatus}";
          on-click = "${caffeineToggle}";
          on-click-right = "systemctl --user stop caffeine";
          tooltip = true;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-warning = "{icon} {capacity}%";
          format-critical = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-full = " {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          tooltip-format = "{time}";
        };

        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "󰤭  Disconnected";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "  No Internet";
          tooltip-format-wifi = "Signal Strength: {signalStrength}%";
          on-click = "alacritty -e nmtui";
        };

        "wireplumber" = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = [ "" "" " " ];
          };
          on-click = "pavucontrol";
          scroll-step = 10;
        };
      };
    };
    style = ''
      /* Make caffeine indicator prominent in the center */
      #custom-caffeine.on {
        color: #ffcc00;
        font-weight: 700;
      }
      #custom-caffeine.off {
        color: #888888;
        font-weight: 600;
      }
      /* Make clock bold for better visibility */
      #clock {
        font-weight: 700;
      }
      /* Add spacing/padding to power and notifications icons */
      #custom-power {
        padding-left: 12px;
        padding-right: 12px;
      }
      #custom-notifications {
        padding-left: 12px;
        padding-right: 8px;
      }
    '';
  };
}
