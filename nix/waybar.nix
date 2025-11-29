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
    style = ''
      @import "mocha.css"; 

      * {
          font-family: "JetBrainsMono NF";
          font-size: 16px;
          min-height: 0;
          font-weight: bold;
      }

      window#waybar {
          background: transparent;
          background-color: @crust;
          color: @overlay0;
          transition-property: background-color;
          transition-duration: 0.1s;
          border-bottom: 1px solid @overlay1;
      }

      #window {
          margin: 8px;
          padding-left: 8px;
          padding-right: 8px;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
      }

      button:hover {
          background: inherit;
          color: @mauve;
          border-top: 2px solid @mauve;
      }

      #workspaces button {
          padding: 0 4px;
          color: @text;
      }

      #workspaces button.focused {
          background-color: rgba(0, 0, 0, 0.3);
          color: @rosewater;
          border-top: 2px solid @rosewater;
      }

      #workspaces button.active {
          background-color: rgba(0, 0, 0, 0.3);
          color: @mauve;
          border-top: 2px solid @mauve;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #wireplumber,
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #wireplumber,
      #tray,
      #network,
      #bluetooth,
      #mode,
      #custom-power,
      #custom-notifications,
      #scratchpad {
        margin-top: 2px;
        margin-bottom: 2px;
        margin-left: 4px;
        margin-right: 4px;
        padding-left: 4px;
        padding-right: 4px;
      }

      #bluetooth {
          color: @lavender;
          border-bottom: 2px solid @lavender;
      }

      #cpu {
          color: @green;
          border-bottom: 2px solid @green;
      }

      #memory {
          color: @sky;
          border-bottom: 2px solid @sky;
      }

      #clock {
          color: @maroon;
          border-bottom: 2px solid @maroon;
      }

      #clock.date {
          color: @mauve;
          border-bottom: 2px solid @mauve;
      }

      #wireplumber {
          color: @blue;
          border-bottom: 2px solid @blue;
      }

      #network {
          color: @yellow;
          border-bottom: 2px solid @yellow;
      }

      #network.disconnected {
          color: @red; /* Disconnected color */
          border-bottom: 2px solid @red;
      }

      #idle_inhibitor {
          margin-right: 12px;
          color: #7cb342;
      }

      #idle_inhibitor.activated {
          color: @red;
      }

      #battery {
          color: @teal;
          border-bottom: 2px solid @green; /* Default border */
      }

      #battery.warning {
          color: @yellow; /* Warning color */
          border-bottom: 2px solid @yellow; /* Warning border */
      }

      #battery.critical {
          color: @red; /* Critical color */
          border-bottom: 2px solid @red; /* Critical border */
      }

      #battery.charging {
          color: @green; /* Charging color */
          border-bottom: 2px solid @teal; /* Charging border */
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left>widget:first-child>#workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right>widget:last-child>#workspaces {
          margin-right: 0;
      }

      #custom-vpn {
          color: @lavender;
          border-radius: 15px;
          padding-left: 6px;
          padding-right: 6px;
      }

      #custom-power {
          color: @maroon;
      }

      #custom-notifications {
        color: @peach;
      }
    '';
  };
}
