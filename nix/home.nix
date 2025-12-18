{ pkgs, config, inputs, unstablePkgs, helium-browser, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./mpv.nix
    ./swaync.nix
  ];

  home.packages = with pkgs; [
    # User applications
    _64gram
    #floorp-bin
    brave
    helium-browser
    libreoffice-qt6-fresh
    motrix
    viewnior
    zapzap

    # Development tools
    unstablePkgs.android-studio
    unstablePkgs.vscode
    unstablePkgs.code-cursor
    unstablePkgs.unityhub
    arduino-ide
    docker
    docker-compose
    espeak
    gcc
    gnumake
    linuxHeaders
    flac
    neovim
    portaudio
    libpulseaudio
    nodejs_24
    pnpm
    python313
    uv

    # Terminal utilities
    bat
    bluetuith
    bottom
    broot
    dust
    eza
    fastfetch
    fd
    fzf
    gh
    htop
    hyperfine
    procs
    playerctl
    portaudio
    ranger
    ripgrep
    swaynotificationcenter
    swayosd
    tldr
    unstablePkgs.gemini-cli
    unstablePkgs.hyprmon
    wget
    xplr
    zoxide

    # File management & archives
    p7zip
    unzip
    unrar
    xfce.thunar

    # Desktop utilities
    pavucontrol
    wofi
    libnotify

    # Fonts
    pkgs.nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  systemd.user.services.caffeine = {
    Unit = {
      Description = "Keep the session awake (inhibit idle/sleep)";
    };
    Service = {
      Type = "simple";
      ExecStart = ''${pkgs.systemd}/bin/systemd-inhibit --what=idle:sleep --mode=block --why=Caffeine ${pkgs.coreutils}/bin/sleep infinity'';
    };
    Install = {
      WantedBy = [ ];
    };
  };

  systemd.user.services.swayosd-libinput-backend = {
    Unit = {
      Description = "SwayOSD LibInput listener backend for keyboard indicators";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = ''${pkgs.swayosd}/bin/swayosd-libinput-backend'';
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.sessionVariables = {
    PATH = "${pkgs.flac}/bin:$PATH";
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window.padding = { x = 10; y = 10; };
      };
    };

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        user.name = "sharifmdathar";
        user.email = "116189751+sharifmdathar@users.noreply.github.com";
      };
    };

    git-credential-oauth.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        nix_shell = {
          disabled = false;
          symbol = "❄";
          format = "[$symbol$state]($style) ";
        };
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";
        lt = "eza --tree";
        cat = "bat";
        du = "dust";
        find = "fd";
        grep = "rg";
        ps = "procs";
        man = "tldr";
        tree = "broot";
        top = "btm";
        nnn = "xplr";
      };
    };
  };

  gtk = {
    enable = true;
  };

  xdg.desktopEntries.helium-browser = {
    name = "Helium Browser";
    genericName = "Web Browser";
    exec = "helium-browser %U";
    icon = "helium-browser";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "application/xml" "application/vnd.mozilla.xul+xml" "application/rss+xml" "application/rdf+xml" "image/svg+xml" ];
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "helium-browser.desktop";
    "x-scheme-handler/http" = "helium-browser.desktop";
    "x-scheme-handler/https" = "helium-browser.desktop";
    "x-scheme-handler/about" = "helium-browser.desktop";
    "x-scheme-handler/unknown" = "helium-browser.desktop";
  };

  stylix.targets.mako.enable = false;

  home.homeDirectory = "/home/blazen";
  home.stateVersion = "25.11";
  home.username = "blazen";

  programs.home-manager.enable = true;
}
