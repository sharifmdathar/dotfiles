{ pkgs, config, inputs, unstablePkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./mpv.nix
    ./swaync.nix
  ];

  home.packages = with pkgs; [
    _64gram
    bluetuith
    fastfetch
    neovim
    pnpm
    ranger
    ripgrep
    swaynotificationcenter
    swayosd
    unzip
    unrar
    unstablePkgs.vscode
    unstablePkgs.android-studio
    viewnior
    wget
    zapzap

    pkgs.nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

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
      userName = "sharifmdathar";
      userEmail = "116189751+sharifmdathar@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
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
  };

  gtk = {
    enable = true;
  };

  stylix.targets.mako.enable = false;

  home.homeDirectory = "/home/blazen";
  home.stateVersion = "25.05";
  home.username = "blazen";

  programs.home-manager.enable = true;
}