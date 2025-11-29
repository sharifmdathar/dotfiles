# Edit this configuration file to define what should be installed on your system.
# Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./home.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/disk/by-uuid/d57a97f3-74e3-4f19-8e4b-40f951fdf610";
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    dhcpcd.wait = "background";
    firewall.enable = false;
  };
  systemd.services."NetworkManager-wait-online".enable = false;

  security = {
    polkit.enable = true;
    rtkit.enable = true; # For Audio
    pam.services.hyprlock = {};
  };
 
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    graphics.enable = true;
    nvidia = {
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = true;
      nvidiaSettings = false;
    };
  };


  environment = {
    etc."greetd/environments".text = "Hyprland";
    systemPackages = with pkgs; [
      adwaita-icon-theme
      brightnessctl
      cliphist
      gnome-themes-extra
      hyprland
      hyprpolkitagent
      hyprshot
      nodejs_24
      p7zip
      pavucontrol
      udiskie
      waybar
      firefox
      wl-clipboard
      wofi
      xdg-utils
      xfce.thunar
    ];
    variables.GTK_THEME = "Adwaita:dark";
  };

  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    cloudflare-warp.enable = true;
    create_ap = {
      enable = false;
      settings = {
        INTERNET_IFACE = "enp3s0";
        WIFI_IFACE = "wlp0s20f3";
        FREQ_BAND = "2.4";
        SSID = "My Hotspot";
        PASSPHRASE = "password";
      };
    };
    gvfs.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "Hyprland";
          user = "blazen";
        };
      };
    };
    logind.powerKey = "suspend-then-hibernate";
    logind.suspendKey = "ignore";
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    udisks2.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.blazen = {
      isNormalUser = true;
      description = "Blazen";
      extraGroups = [ "networkmanager" "wheel" "kvm" "adbusers" ];
    };
  };

  programs = {
    hyprland.enable = true;
    thunderbird.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      shellAliases = {
        gst = "git status";
      };
      interactiveShellInit = ''
        bindkey "^[[1;5D" backward-word  # Ctrl + Left
        bindkey "^[[1;5C" forward-word   # Ctrl + Right
        export EDITOR="nvim"
        export VISUAL="nvim"
        export SUDO_EDITOR="nvim"
      '';
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}

