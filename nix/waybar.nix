{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        modules-left = [ "hyprland/workspaces" "memory" "cpu" ];
        modules-center = [ "clock" "hyprland/window" ]; 
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
  };
}
