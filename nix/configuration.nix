# Edit this configuration file to define what should be installed on your system.
# Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  stylix = {
    enable = true;
    image = ./wallpaper.jpg;
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "pstore.disable=1"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "sd_mod"
    ];

    extraModulePackages = [ config.boot.kernelPackages.tuxedo-keyboard ];
    extraModprobeConfig = ''
      options tuxedo_keyboard color=WHITE
    '';
    supportedFilesystems = [ "ntfs" ];
  };

  powerManagement.cpuFreqGovernor = "schedutil";
  powerManagement.powertop.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  services.journald = {
    rateLimitInterval = "30s";
    rateLimitBurst = 200;
    extraConfig = ''
      SystemMaxUse=200M
    '';
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
      # System-level theming & core utilities
      adwaita-icon-theme
      gnome-themes-extra
      xdg-utils

      # Hyprland ecosystem (system-level)
      hyprland
      hyprpolkitagent
      waybar
      brightnessctl
      cliphist
      hyprshot
      wl-clipboard

      # System utilities
      udiskie
      ntfs3g
    ];

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
    logind.settings.Login = {
      HandlePowerKey = "suspend-then-hibernate";
      HandleSuspendKey = "ignore";
    };
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

  systemd.services."tuxedo-keyboard-late" = {
    description = "Load tuxedo_keyboard module after boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe tuxedo_keyboard";
    };
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
    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          turbo = "auto";
          energy_performance_preference = "performance";
        };
        battery = {
          governor = "powersave";
          turbo = "auto";
          energy_performance_preference = "power";
        };
      };
    };
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  system.stateVersion = "25.11";
}

