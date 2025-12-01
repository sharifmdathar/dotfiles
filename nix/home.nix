{ pkgs, config, inputs, unstablePkgs, ... }:

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
    firefox
    google-chrome
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
    gcc
    gnumake
    neovim
    nodejs_24
    pnpm

    # Terminal utilities
    bluetuith
    fastfetch
    ranger
    ripgrep
    swaynotificationcenter
    swayosd
    unstablePkgs.gemini-cli
    wget

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

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  gtk = {
    enable = true;
  };

  stylix.targets.mako.enable = false;

  home.homeDirectory = "/home/blazen";
  home.stateVersion = "25.11";
  home.username = "blazen";

  programs.home-manager.enable = true;
}