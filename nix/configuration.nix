# Edit this configuration file to define what should be installed on your system.
# Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running 'nixos-help').

{
  config,
  pkgs,
  inputs,
  helium-browser,
  ...
}:

let
  swayosd-dbus-policy = pkgs.writeText "org.erikreider.swayosd-user.conf" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN" "https://specifications.freedesktop.org/dbus/introspect-latest.dtd">
    <busconfig>
      <!-- Allow user blazen to own the service -->
      <policy user="blazen">
        <allow own="org.erikreider.swayosd" />
      </policy>
      <!-- Anyone can talk to the main interface -->
      <policy context="default">
        <allow send_destination="org.erikreider.swayosd" send_interface="org.erikreider.swayosd" />
        <allow send_destination="org.erikreider.swayosd"
          send_interface="org.freedesktop.DBus.Introspectable" />
        <allow send_destination="org.erikreider.swayosd"
          send_interface="org.freedesktop.DBus.Properties" />
        <allow send_destination="org.erikreider.swayosd" send_interface="org.freedesktop.DBus.Peer" />
      </policy>
    </busconfig>
  '';

  swayosd-with-user-policy = pkgs.symlinkJoin {
    name = "swayosd-with-user-policy";
    paths = [ pkgs.swayosd ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      # Override the DBus policy file
      rm -f $out/share/dbus-1/system.d/org.erikreider.swayosd.conf
      cp ${swayosd-dbus-policy} $out/share/dbus-1/system.d/org.erikreider.swayosd.conf
    '';
  };
in

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "pstore.disable=1"
      "resume=/dev/disk/by-uuid/987fa509-174f-49a1-9829-19572a44cf29"
      "mem_sleep_default=deep"
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
    hosts = {
      "172.16.254.1" = [
        "cyberoam.iiitnr.edu.in"
      ];
    };
  };
  systemd.services."NetworkManager-wait-online".enable = false;

  services.udev.extraRules = ''
    # Disable autosuspend for USB OPTICAL MOUSE
    ATTR{idVendor}=="0000", ATTR{idProduct}=="3825", TEST=="power/control", ATTR{power/control}="on"
  '';

  security = {
    polkit.enable = true;
    rtkit.enable = true; # For Audio
    pam.services.hyprlock = { };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
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

      # Custom packages
      helium-browser
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
    dbus = {
      packages = [ swayosd-with-user-policy ];
    };
    create_ap = {
      enable = false;
      settings = {
        INTERNET_IFACE = "enp3s0";
        WIFI_IFACE = "wlp0s20f3";
        FREQ_BAND = "2.4";
        SSID = "My Hotspot";
        PASSPHRASE = "password";
        NO_VIRT = "1";
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
      HandleLidSwitch = "suspend-then-hibernate";
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

  virtualisation.docker.enable = false;

  systemd.services."tuxedo-keyboard-late" = {
    description = "Load tuxedo_keyboard module after boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe tuxedo_keyboard";
    };
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
    HibernateMode=platform shutdown
  '';

  users = {
    defaultUserShell = pkgs.zsh;
    users.blazen = {
      isNormalUser = true;
      description = "Blazen";
      extraGroups = [
        "networkmanager"
        "wheel"
        "kvm"
        "adbusers"
        "input"
        "audio"
      ];
    };
  };

  programs = {
    zsh.enable = true;
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
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://attic.xuyh0120.win/lantian"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };

  system.stateVersion = "25.11";
}
